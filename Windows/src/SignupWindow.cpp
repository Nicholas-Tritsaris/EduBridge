#include "SignupWindow.h"
#include <regex>

static std::map<HWND, SignupWindow*> signupWindowMap;

SignupWindow::SignupWindow() : hWnd(NULL), hEmailEdit(NULL), hPasswordEdit(NULL),
hConfirmPasswordEdit(NULL), hSignupButton(NULL), hBackButton(NULL), hStatusText(NULL) {}

SignupWindow::~SignupWindow() {
    if (hWnd) {
        DestroyWindow(hWnd);
    }
}

bool SignupWindow::Create() {
    WNDCLASS wc = {};
    wc.lpfnWndProc = WindowProc;
    wc.hInstance = GetModuleHandle(NULL);
    wc.lpszClassName = L"EduBridge_SignupWindow";
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);

    if (!RegisterClass(&wc)) {
        return false;
    }

    hWnd = CreateWindowEx(
        0,
        L"EduBridge_SignupWindow",
        L"EduBridge - Sign Up",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, 500, 650,
        NULL, NULL, GetModuleHandle(NULL), this
    );

    if (!hWnd) {
        return false;
    }

    signupWindowMap[hWnd] = this;
    CreateControls();
    return true;
}

void SignupWindow::Show() {
    if (hWnd) {
        ShowWindow(hWnd, SW_SHOW);
    }
}

void SignupWindow::Hide() {
    if (hWnd) {
        ShowWindow(hWnd, SW_HIDE);
    }
}

bool SignupWindow::IsVisible() const {
    return hWnd && IsWindowVisible(hWnd);
}

void SignupWindow::CreateControls() {
    HFONT hFont = CreateFont(14, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE,
        DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
        DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, L"Segoe UI");

    // Title
    CreateWindowEx(0, L"STATIC", L"Create Your Account",
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
    CreateWindowEx(0, L"STATIC", L"Password (min 6 characters):",
        WS_CHILD | WS_VISIBLE,
        20, 130, 460, 20, hWnd, NULL, GetModuleHandle(NULL), NULL);

    // Password input
    hPasswordEdit = CreateWindowEx(WS_EX_CLIENTEDGE, L"EDIT", L"",
        WS_CHILD | WS_VISIBLE | ES_PASSWORD | ES_AUTOHSCROLL,
        20, 150, 460, 35, hWnd, NULL, GetModuleHandle(NULL), NULL);
    SendMessage(hPasswordEdit, WM_SETFONT, (WPARAM)hFont, TRUE);

    // Confirm password label
    CreateWindowEx(0, L"STATIC", L"Confirm Password:",
        WS_CHILD | WS_VISIBLE,
        20, 190, 460, 20, hWnd, NULL, GetModuleHandle(NULL), NULL);

    // Confirm password input
    hConfirmPasswordEdit = CreateWindowEx(WS_EX_CLIENTEDGE, L"EDIT", L"",
        WS_CHILD | WS_VISIBLE | ES_PASSWORD | ES_AUTOHSCROLL,
        20, 210, 460, 35, hWnd, NULL, GetModuleHandle(NULL), NULL);
    SendMessage(hConfirmPasswordEdit, WM_SETFONT, (WPARAM)hFont, TRUE);

    // Signup button
    hSignupButton = CreateWindowEx(0, L"BUTTON", L"Create Account",
        WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON,
        20, 260, 220, 40, hWnd, (HMENU)2001, GetModuleHandle(NULL), NULL);
    SendMessage(hSignupButton, WM_SETFONT, (WPARAM)hFont, TRUE);

    // Back button
    hBackButton = CreateWindowEx(0, L"BUTTON", L"Back",
        WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON,
        260, 260, 220, 40, hWnd, (HMENU)2002, GetModuleHandle(NULL), NULL);
    SendMessage(hBackButton, WM_SETFONT, (WPARAM)hFont, TRUE);

    // Status text
    hStatusText = CreateWindowEx(0, L"STATIC", L"",
        WS_CHILD | WS_VISIBLE | SS_WORDELLIPSIS,
        20, 310, 460, 100, hWnd, NULL, GetModuleHandle(NULL), NULL);
    SendMessage(hStatusText, WM_SETFONT, (WPARAM)hFont, TRUE);

    DeleteObject(hFont);
}

std::string SignupWindow::GetEditText(HWND hEdit) {
    int len = GetWindowTextLength(hEdit) + 1;
    wchar_t* buffer = new wchar_t[len];
    GetWindowText(hEdit, buffer, len);

    int size = WideCharToMultiByte(CP_UTF8, 0, buffer, -1, NULL, 0, NULL, NULL);
    std::string result(size - 1, 0);
    WideCharToMultiByte(CP_UTF8, 0, buffer, -1, &result[0], size, NULL, NULL);

    delete[] buffer;
    return result;
}

bool SignupWindow::ValidateEmail(const std::string& email) {
    std::regex emailRegex(R"(^[^\s@]+@[^\s@]+\.[^\s@]+$)");
    return std::regex_match(email, emailRegex);
}

bool SignupWindow::ValidatePassword(const std::string& password) {
    return password.length() >= 6;
}

void SignupWindow::UpdateStatus(const std::string& message, bool isError) {
    std::wstring wMessage(message.begin(), message.end());
    SetWindowText(hStatusText, wMessage.c_str());
}

void SignupWindow::OnSignupClick() {
    std::string email = GetEditText(hEmailEdit);
    std::string password = GetEditText(hPasswordEdit);
    std::string confirmPassword = GetEditText(hConfirmPasswordEdit);

    if (email.empty() || password.empty() || confirmPassword.empty()) {
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

    if (password != confirmPassword) {
        UpdateStatus("Passwords do not match", true);
        return;
    }

    UpdateStatus("Creating account...", false);
    EnableWindow(hSignupButton, FALSE);
    EnableWindow(hBackButton, FALSE);
    EnableWindow(hEmailEdit, FALSE);
    EnableWindow(hPasswordEdit, FALSE);
    EnableWindow(hConfirmPasswordEdit, FALSE);

    Json::Value jsonData;
    jsonData["email"] = email;
    jsonData["password"] = password;

    std::string response = httpClient.Post("http://localhost:5000/api/auth/signup", jsonData);

    if (response.empty()) {
        UpdateStatus("Network error: " + httpClient.GetLastError(), true);
    } else {
        Json::Value jsonResponse = httpClient.ParseJson(response);
        if (jsonResponse.isMember("success") && jsonResponse["success"].asBool()) {
            UpdateStatus("Account created! Check your email for verification code.", false);
        } else {
            std::string errorMsg = jsonResponse.isMember("message") ?
                jsonResponse["message"].asString() : "Signup failed";
            UpdateStatus(errorMsg, true);
        }
    }

    EnableWindow(hSignupButton, TRUE);
    EnableWindow(hBackButton, TRUE);
    EnableWindow(hEmailEdit, TRUE);
    EnableWindow(hPasswordEdit, TRUE);
    EnableWindow(hConfirmPasswordEdit, TRUE);
}

void SignupWindow::OnBackClick() {
    Hide();
}

LRESULT CALLBACK SignupWindow::WindowProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    SignupWindow* pThis = nullptr;

    if (msg == WM_CREATE) {
        CREATESTRUCT* pCreate = reinterpret_cast<CREATESTRUCT*>(lParam);
        pThis = reinterpret_cast<SignupWindow*>(pCreate->lpCreateParams);
        signupWindowMap[hwnd] = pThis;
    } else {
        pThis = signupWindowMap[hwnd];
    }

    if (pThis) {
        return pThis->HandleMessage(msg, wParam, lParam);
    }

    return DefWindowProc(hwnd, msg, wParam, lParam);
}

LRESULT CALLBACK SignupWindow::HandleMessage(UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
    case WM_COMMAND:
        if (LOWORD(wParam) == 2001) {
            OnSignupClick();
        } else if (LOWORD(wParam) == 2002) {
            OnBackClick();
        }
        return 0;

    case WM_DESTROY:
        signupWindowMap.erase(hWnd);
        return 0;
    }

    return DefWindowProc(hWnd, msg, wParam, lParam);
}
