#include "LoginWindow.h"
#include <regex>
#include <sstream>

// Map to store instance pointers
static std::map<HWND, LoginWindow*> windowMap;

LoginWindow::LoginWindow() : hWnd(NULL), hEmailEdit(NULL), hPasswordEdit(NULL),
hLoginButton(NULL), hSignupButton(NULL), hStatusText(NULL), hLoadingLabel(NULL) {}

LoginWindow::~LoginWindow() {
    if (hWnd) {
        DestroyWindow(hWnd);
    }
}

bool LoginWindow::Create() {
    // Register window class
    WNDCLASS wc = {};
    wc.lpfnWndProc = WindowProc;
    wc.hInstance = GetModuleHandle(NULL);
    wc.lpszClassName = L"EduBridge_LoginWindow";
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);

    if (!RegisterClass(&wc)) {
        return false;
    }

    // Create window
    hWnd = CreateWindowEx(
        0,
        L"EduBridge_LoginWindow",
        L"EduBridge - Login",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, 500, 600,
        NULL, NULL, GetModuleHandle(NULL), this
    );

    if (!hWnd) {
        return false;
    }

    windowMap[hWnd] = this;
    CreateControls();
    return true;
}

void LoginWindow::Show() {
    if (hWnd) {
        ShowWindow(hWnd, SW_SHOW);
    }
}

void LoginWindow::Hide() {
    if (hWnd) {
        ShowWindow(hWnd, SW_HIDE);
    }
}

bool LoginWindow::IsVisible() const {
    return hWnd && IsWindowVisible(hWnd);
}

void LoginWindow::CreateControls() {
    HFONT hFont = CreateFont(14, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE,
        DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
        DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, L"Segoe UI");

    // Title
    CreateWindowEx(0, L"STATIC", L"EduBridge Login",
        WS_CHILD | WS_VISIBLE | SS_CENTER,
        20, 20, 460, 40, hWnd, NULL, GetModuleHandle(NULL), NULL);

    // Email label
    CreateWindowEx(0, L"STATIC", L"Email Address:",
        WS_CHILD | WS_VISIBLE,
        20, 70, 460, 20, hWnd, NULL, GetModuleHandle(NULL), NULL);

    // Email input
    hEmailEdit = CreateWindowEx(WS_EX_CLIENTEDGE, L"EDIT", L"",
        WS_CHILD | WS_VISIBLE | ES_AUTOHSCROLL,
        20, 90, 460, 35, hWnd, NULL, GetModuleHandle(NULL), NULL);
    SendMessage(hEmailEdit, WM_SETFONT, (WPARAM)hFont, TRUE);

    // Password label
    CreateWindowEx(0, L"STATIC", L"Password:",
        WS_CHILD | WS_VISIBLE,
        20, 130, 460, 20, hWnd, NULL, GetModuleHandle(NULL), NULL);

    // Password input
    hPasswordEdit = CreateWindowEx(WS_EX_CLIENTEDGE, L"EDIT", L"",
        WS_CHILD | WS_VISIBLE | ES_PASSWORD | ES_AUTOHSCROLL,
        20, 150, 460, 35, hWnd, NULL, GetModuleHandle(NULL), NULL);
    SendMessage(hPasswordEdit, WM_SETFONT, (WPARAM)hFont, TRUE);

    // Login button
    hLoginButton = CreateWindowEx(0, L"BUTTON", L"Sign In",
        WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON,
        20, 200, 220, 40, hWnd, (HMENU)1001, GetModuleHandle(NULL), NULL);
    SendMessage(hLoginButton, WM_SETFONT, (WPARAM)hFont, TRUE);

    // Signup button
    hSignupButton = CreateWindowEx(0, L"BUTTON", L"Sign Up",
        WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON,
        260, 200, 220, 40, hWnd, (HMENU)1002, GetModuleHandle(NULL), NULL);
    SendMessage(hSignupButton, WM_SETFONT, (WPARAM)hFont, TRUE);

    // Status text
    hStatusText = CreateWindowEx(0, L"STATIC", L"",
        WS_CHILD | WS_VISIBLE | SS_WORDELLIPSIS,
        20, 250, 460, 80, hWnd, NULL, GetModuleHandle(NULL), NULL);
    SendMessage(hStatusText, WM_SETFONT, (WPARAM)hFont, TRUE);

    // Loading label
    hLoadingLabel = CreateWindowEx(0, L"STATIC", L"",
        WS_CHILD | SS_CENTER,
        20, 340, 460, 220, hWnd, NULL, GetModuleHandle(NULL), NULL);
    SendMessage(hLoadingLabel, WM_SETFONT, (WPARAM)hFont, TRUE);

    DeleteObject(hFont);
}

std::string LoginWindow::GetEditText(HWND hEdit) {
    int len = GetWindowTextLength(hEdit) + 1;
    wchar_t* buffer = new wchar_t[len];
    GetWindowText(hEdit, buffer, len);

    // Convert wide to UTF-8
    int size = WideCharToMultiByte(CP_UTF8, 0, buffer, -1, NULL, 0, NULL, NULL);
    std::string result(size - 1, 0);
    WideCharToMultiByte(CP_UTF8, 0, buffer, -1, &result[0], size, NULL, NULL);

    delete[] buffer;
    return result;
}

bool LoginWindow::ValidateEmail(const std::string& email) {
    std::regex emailRegex(R"(^[^\s@]+@[^\s@]+\.[^\s@]+$)");
    return std::regex_match(email, emailRegex);
}

bool LoginWindow::ValidatePassword(const std::string& password) {
    return password.length() >= 6;
}

void LoginWindow::UpdateStatus(const std::string& message, bool isError) {
    std::wstring wMessage(message.begin(), message.end());
    SetWindowText(hStatusText, wMessage.c_str());
}

void LoginWindow::OnLoginClick() {
    std::string email = GetEditText(hEmailEdit);
    std::string password = GetEditText(hPasswordEdit);

    if (email.empty() || password.empty()) {
        UpdateStatus("Please fill in all fields", true);
        return;
    }

    if (!ValidateEmail(email)) {
        UpdateStatus("Invalid email address", true);
        return;
    }

    if (!ValidatePassword(password)) {
        UpdateStatus("Password must be at least 6 characters", true);
        return;
    }

    UpdateStatus("Logging in...", false);
    EnableWindow(hLoginButton, FALSE);
    EnableWindow(hSignupButton, FALSE);
    EnableWindow(hEmailEdit, FALSE);
    EnableWindow(hPasswordEdit, FALSE);

    // Prepare JSON request
    Json::Value jsonData;
    jsonData["email"] = email;
    jsonData["password"] = password;

    std::string response = httpClient.Post("http://input ip here:5000/api/auth/login", jsonData);

    if (response.empty()) {
        UpdateStatus("Network error: " + httpClient.GetLastError(), true);
    } else {
        Json::Value jsonResponse = httpClient.ParseJson(response);
        if (jsonResponse.isMember("success") && jsonResponse["success"].asBool()) {
            UpdateStatus("Login successful! Welcome to EduBridge!", false);
        } else {
            std::string errorMsg = jsonResponse.isMember("message") ?
                jsonResponse["message"].asString() : "Login failed";
            UpdateStatus(errorMsg, true);
        }
    }

    EnableWindow(hLoginButton, TRUE);
    EnableWindow(hSignupButton, TRUE);
    EnableWindow(hEmailEdit, TRUE);
    EnableWindow(hPasswordEdit, TRUE);
}

void LoginWindow::OnSignupClick() {
    UpdateStatus("Signup feature coming soon!", false);
}

LRESULT CALLBACK LoginWindow::WindowProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    LoginWindow* pThis = nullptr;

    if (msg == WM_CREATE) {
        CREATESTRUCT* pCreate = reinterpret_cast<CREATESTRUCT*>(lParam);
        pThis = reinterpret_cast<LoginWindow*>(pCreate->lpCreateParams);
        windowMap[hwnd] = pThis;
    } else {
        pThis = windowMap[hwnd];
    }

    if (pThis) {
        return pThis->HandleMessage(msg, wParam, lParam);
    }

    return DefWindowProc(hwnd, msg, wParam, lParam);
}

LRESULT CALLBACK LoginWindow::HandleMessage(UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
    case WM_COMMAND:
        if (LOWORD(wParam) == 1001) {
            OnLoginClick();
        } else if (LOWORD(wParam) == 1002) {
            OnSignupClick();
        }
        return 0;

    case WM_DESTROY:
        windowMap.erase(hWnd);
        PostQuitMessage(0);
        return 0;
    }

    return DefWindowProc(hWnd, msg, wParam, lParam);
}
