<?php
// contact-handler.php - Handles contact form submissions and email notifications

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get form data
    $name = isset($_POST['name']) ? htmlspecialchars(trim($_POST['name'])) : '';
    $email = isset($_POST['email']) ? htmlspecialchars(trim($_POST['email'])) : '';
    $subject = isset($_POST['subject']) ? htmlspecialchars(trim($_POST['subject'])) : '';
    $message = isset($_POST['message']) ? htmlspecialchars(trim($_POST['message'])) : '';

    // Validate input
    if (empty($name) || empty($email) || empty($subject) || empty($message)) {
        echo json_encode([
            'success' => false,
            'message' => 'All fields are required'
        ]);
        exit;
    }

    // Validate email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode([
            'success' => false,
            'message' => 'Invalid email address'
        ]);
        exit;
    }

    // Validate message length
    if (strlen($message) < 10) {
        echo json_encode([
            'success' => false,
            'message' => 'Message must be at least 10 characters long'
        ]);
        exit;
    }

    // Prepare email
    $to = 'edubridge.au';
    $headers = "From: $email\r\n";
    $headers .= "Reply-To: $email\r\n";
    $headers .= "Content-Type: text/html; charset=UTF-8\r\n";

    // Create HTML email body
    $email_body = "<html><body>";
    $email_body .= "<h2 style='color: #667eea;'>New Contact Form Submission</h2>";
    $email_body .= "<p><strong>Name:</strong> $name</p>";
    $email_body .= "<p><strong>Email:</strong> $email</p>";
    $email_body .= "<p><strong>Subject:</strong> $subject</p>";
    $email_body .= "<p><strong>Message:</strong></p>";
    $email_body .= "<p>" . nl2br($message) . "</p>";
    $email_body .= "<hr>";
    $email_body .= "<p style='color: #999; font-size: 12px;'>Message sent from EduBridge website</p>";
    $email_body .= "</body></html>";

    // Send email
    if (mail($to, "EduBridge Contact: $subject", $email_body, $headers)) {
        // Send confirmation email to user
        $user_subject = "We received your message - EduBridge";
        $user_body = "<html><body>";
        $user_body .= "<h2 style='color: #667eea;'>Thank you for contacting EduBridge</h2>";
        $user_body .= "<p>Hi $name,</p>";
        $user_body .= "<p>We received your message and will get back to you as soon as possible.</p>";
        $user_body .= "<p><strong>Your subject:</strong> $subject</p>";
        $user_body .= "<p>Best regards,<br>EduBridge Team</p>";
        $user_body .= "</body></html>";

        $user_headers = "From: edubridge.au\r\n";
        $user_headers .= "Content-Type: text/html; charset=UTF-8\r\n";

        mail($email, $user_subject, $user_body, $user_headers);

        echo json_encode([
            'success' => true,
            'message' => 'Message sent successfully! We will get back to you soon.'
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Failed to send message. Please try again later or contact us directly.'
        ]);
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid request method'
    ]);
}
?>