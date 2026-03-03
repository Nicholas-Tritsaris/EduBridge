#pragma once
#ifndef HTTPCLIENT_H
#define HTTPCLIENT_H

#include <string>
#include <map>
#include <json/json.h>
#include <windows.h>
#include <winhttp.h>

#pragma comment(lib, "winhttp.lib")
#pragma comment(lib, "ws2_32.lib")

class HttpClient {
public:
    HttpClient();
    ~HttpClient();

    // GET request
    std::string Get(const std::string& url);

    // POST request with JSON body
    std::string Post(const std::string& url, const Json::Value& data);

    // Parse JSON response
    Json::Value ParseJson(const std::string& jsonStr);

    // Get last error message
    std::string GetLastError() const;

private:
    std::string lastError;
    const std::wstring serverUrl = L"localhost:5000";
    const std::wstring secondaryServerUrl = L"127.0.0.1:5000";

    // Helper methods
    std::string WideToUtf8(const std::wstring& wide);
    std::wstring Utf8ToWide(const std::string& utf8);
    bool ParseUrl(const std::string& url, std::wstring& host, std::wstring& path);
};

#endif // HTTPCLIENT_H
