#include "HttpClient.h"
#include <sstream>
#include <codecvt>
#include <locale>
#include <iostream>

HttpClient::HttpClient() : lastError("") {}

HttpClient::~HttpClient() {}

std::wstring HttpClient::Utf8ToWide(const std::string& utf8) {
    if (utf8.empty()) return std::wstring();
    int size_needed = MultiByteToWideChar(CP_UTF8, 0, &utf8[0], (int)utf8.size(), NULL, 0);
    std::wstring wstr(size_needed, 0);
    MultiByteToWideChar(CP_UTF8, 0, &utf8[0], (int)utf8.size(), &wstr[0], size_needed);
    return wstr;
}

std::string HttpClient::WideToUtf8(const std::wstring& wide) {
    if (wide.empty()) return std::string();
    int size_needed = WideCharToMultiByte(CP_UTF8, 0, &wide[0], (int)wide.size(), NULL, 0, NULL, NULL);
    std::string str(size_needed, 0);
    WideCharToMultiByte(CP_UTF8, 0, &wide[0], (int)wide.size(), &str[0], size_needed, NULL, NULL);
    return str;
}

bool HttpClient::ParseUrl(const std::string& url, std::wstring& host, std::wstring& path) {
    // Simple URL parser
    std::string cleanUrl = url;
    if (cleanUrl.find("http://") != std::string::npos) {
        cleanUrl = cleanUrl.substr(7);
    } else if (cleanUrl.find("https://") != std::string::npos) {
        cleanUrl = cleanUrl.substr(8);
    }

    size_t slashPos = cleanUrl.find('/');
    if (slashPos != std::string::npos) {
        host = Utf8ToWide(cleanUrl.substr(0, slashPos));
        path = Utf8ToWide(cleanUrl.substr(slashPos));
    } else {
        host = Utf8ToWide(cleanUrl);
        path = L"/";
    }

    return true;
}

std::string HttpClient::Get(const std::string& url) {
    lastError = "";
    
    try {
        std::wstring host, path;
        ParseUrl(url, host, path);

        HINTERNET hSession = WinHttpOpen(L"EduBridge/1.0",
            WINHTTP_ACCESS_TYPE_DEFAULT_PROXY,
            WINHTTP_NO_PROXY_NAME,
            WINHTTP_NO_PROXY_BYPASS, 0);

        if (!hSession) {
            lastError = "Failed to open WinHTTP session";
            return "";
        }

        HINTERNET hConnect = WinHttpConnect(hSession, host.c_str(), INTERNET_DEFAULT_HTTP_PORT, 0);
        if (!hConnect) {
            lastError = "Failed to connect";
            WinHttpCloseHandle(hSession);
            return "";
        }

        HINTERNET hRequest = WinHttpOpenRequest(hConnect, L"GET", path.c_str(),
            NULL, WINHTTP_NO_REFERER, WINHTTP_DEFAULT_ACCEPT_TYPES, 0);

        if (!hRequest) {
            lastError = "Failed to open request";
            WinHttpCloseHandle(hConnect);
            WinHttpCloseHandle(hSession);
            return "";
        }

        BOOL bResults = WinHttpSendRequest(hRequest, WINHTTP_NO_ADDITIONAL_HEADERS, 0, WINHTTP_NO_REQUEST_BODY, 0, 0, 0);

        if (!bResults) {
            lastError = "Failed to send request";
            WinHttpCloseHandle(hRequest);
            WinHttpCloseHandle(hConnect);
            WinHttpCloseHandle(hSession);
            return "";
        }

        bResults = WinHttpReceiveResponse(hRequest, NULL);
        if (!bResults) {
            lastError = "Failed to receive response";
            WinHttpCloseHandle(hRequest);
            WinHttpCloseHandle(hConnect);
            WinHttpCloseHandle(hSession);
            return "";
        }

        std::string responseData;
        DWORD dwSize = 0;

        do {
            dwSize = 0;
            if (!WinHttpQueryDataAvailable(hRequest, &dwSize)) {
                break;
            }

            if (dwSize == 0) break;

            char* pszOutBuffer = new char[dwSize + 1];
            ZeroMemory(pszOutBuffer, dwSize + 1);

            DWORD dwDownloaded = 0;
            if (WinHttpReadData(hRequest, (LPVOID)pszOutBuffer, dwSize, &dwDownloaded)) {
                responseData.append(pszOutBuffer, dwDownloaded);
            }

            delete[] pszOutBuffer;

        } while (dwSize > 0);

        WinHttpCloseHandle(hRequest);
        WinHttpCloseHandle(hConnect);
        WinHttpCloseHandle(hSession);

        return responseData;
    }
    catch (const std::exception& e) {
        lastError = std::string("Exception: ") + e.what();
        return "";
    }
}

std::string HttpClient::Post(const std::string& url, const Json::Value& data) {
    lastError = "";

    try {
        std::wstring host, path;
        ParseUrl(url, host, path);

        Json::StreamWriterBuilder writer;
        std::string jsonBody = Json::writeString(writer, data);

        std::wstring wJsonBody = Utf8ToWide(jsonBody);

        HINTERNET hSession = WinHttpOpen(L"EduBridge/1.0",
            WINHTTP_ACCESS_TYPE_DEFAULT_PROXY,
            WINHTTP_NO_PROXY_NAME,
            WINHTTP_NO_PROXY_BYPASS, 0);

        if (!hSession) {
            lastError = "Failed to open WinHTTP session";
            return "";
        }

        HINTERNET hConnect = WinHttpConnect(hSession, host.c_str(), INTERNET_DEFAULT_HTTP_PORT, 0);
        if (!hConnect) {
            lastError = "Failed to connect";
            WinHttpCloseHandle(hSession);
            return "";
        }

        HINTERNET hRequest = WinHttpOpenRequest(hConnect, L"POST", path.c_str(),
            NULL, WINHTTP_NO_REFERER, WINHTTP_DEFAULT_ACCEPT_TYPES, 0);

        if (!hRequest) {
            lastError = "Failed to open request";
            WinHttpCloseHandle(hConnect);
            WinHttpCloseHandle(hSession);
            return "";
        }

        // Add Content-Type header
        WinHttpAddRequestHeaders(hRequest, L"Content-Type: application/json", (ULONG)-1L, WINHTTP_ADDREQ_FLAG_ADD);

        BOOL bResults = WinHttpSendRequest(hRequest, WINHTTP_NO_ADDITIONAL_HEADERS, 0,
            (LPVOID)jsonBody.c_str(), jsonBody.length(), jsonBody.length(), 0);

        if (!bResults) {
            lastError = "Failed to send request";
            WinHttpCloseHandle(hRequest);
            WinHttpCloseHandle(hConnect);
            WinHttpCloseHandle(hSession);
            return "";
        }

        bResults = WinHttpReceiveResponse(hRequest, NULL);
        if (!bResults) {
            lastError = "Failed to receive response";
            WinHttpCloseHandle(hRequest);
            WinHttpCloseHandle(hConnect);
            WinHttpCloseHandle(hSession);
            return "";
        }

        std::string responseData;
        DWORD dwSize = 0;

        do {
            dwSize = 0;
            if (!WinHttpQueryDataAvailable(hRequest, &dwSize)) {
                break;
            }

            if (dwSize == 0) break;

            char* pszOutBuffer = new char[dwSize + 1];
            ZeroMemory(pszOutBuffer, dwSize + 1);

            DWORD dwDownloaded = 0;
            if (WinHttpReadData(hRequest, (LPVOID)pszOutBuffer, dwSize, &dwDownloaded)) {
                responseData.append(pszOutBuffer, dwDownloaded);
            }

            delete[] pszOutBuffer;

        } while (dwSize > 0);

        WinHttpCloseHandle(hRequest);
        WinHttpCloseHandle(hConnect);
        WinHttpCloseHandle(hSession);

        return responseData;
    }
    catch (const std::exception& e) {
        lastError = std::string("Exception: ") + e.what();
        return "";
    }
}

Json::Value HttpClient::ParseJson(const std::string& jsonStr) {
    Json::Value root;
    std::string errors;

    try {
        Json::CharReaderBuilder builder;
        std::istringstream stream(jsonStr);
        if (!Json::parseFromStream(builder, stream, &root, &errors)) {
            lastError = "JSON parse error: " + errors;
            return Json::Value();
        }
    }
    catch (const std::exception& e) {
        lastError = std::string("Exception during JSON parsing: ") + e.what();
        return Json::Value();
    }

    return root;
}

std::string HttpClient::GetLastError() const {
    return lastError;
}
