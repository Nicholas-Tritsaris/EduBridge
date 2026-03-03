#pragma once
#ifndef LOGINWINDOW_H
#define LOGINWINDOW_H

#include <windows.h>
#include <string>
#include "HttpClient.h"

class LoginWindow {
public:
    LoginWindow();
    ~LoginWindow();

    bool Create();
    void Show();
    void Hide();
    bool IsVisible() const;

private:
    HWND hWnd;
    HWND hEmailEdit;
    HWND hPasswordEdit;
    HWND hLoginButton;
    HWND hSignupButton;
    HWND hStatusText;
    HWND hLoadingLabel;

    HttpClient httpClient;

    // Callbacks
    static LRESULT CALLBACK WindowProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
    LRESULT CALLBACK HandleMessage(UINT msg, WPARAM wParam, LPARAM lParam);

    // Helper methods
    void CreateControls();
    void OnLoginClick();
    void OnSignupClick();
    void UpdateStatus(const std::string& message, bool isError = false);
    std::string GetEditText(HWND hEdit);
    bool ValidateEmail(const std::string& email);
    bool ValidatePassword(const std::string& password);
};

#endif // LOGINWINDOW_H
