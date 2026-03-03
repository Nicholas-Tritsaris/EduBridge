#pragma once
#ifndef SIGNUPWINDOW_H
#define SIGNUPWINDOW_H

#include <windows.h>
#include <string>
#include <map>
#include "HttpClient.h"

class SignupWindow {
public:
    SignupWindow();
    ~SignupWindow();

    bool Create();
    void Show();
    void Hide();
    bool IsVisible() const;

private:
    HWND hWnd;
    HWND hEmailEdit;
    HWND hPasswordEdit;
    HWND hConfirmPasswordEdit;
    HWND hSignupButton;
    HWND hBackButton;
    HWND hStatusText;

    HttpClient httpClient;

    // Callbacks
    static LRESULT CALLBACK WindowProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
    LRESULT CALLBACK HandleMessage(UINT msg, WPARAM wParam, LPARAM lParam);

    // Helper methods
    void CreateControls();
    void OnSignupClick();
    void OnBackClick();
    void UpdateStatus(const std::string& message, bool isError = false);
    std::string GetEditText(HWND hEdit);
    bool ValidateEmail(const std::string& email);
    bool ValidatePassword(const std::string& password);
};

#endif // SIGNUPWINDOW_H
