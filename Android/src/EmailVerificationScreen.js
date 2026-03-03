// Android/src/EmailVerificationScreen.js
import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  ActivityIndicator,
  Alert,
  ScrollView,
  SafeAreaView,
} from 'react-native';
import { authApi } from './ApiService';

const EmailVerificationScreen = ({ route, navigation }) => {
  const { email } = route.params;
  const [code, setCode] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleVerify = async () => {
    setError('');

    if (!code) {
      setError('Please enter the verification code');
      return;
    }

    if (code.length < 6) {
      setError('Verification code should be 6 characters');
      return;
    }

    setLoading(true);

    try {
      const response = await authApi.verifyEmail(email, code);

      if (response.data.success) {
        Alert.alert('Success', 'Email verified successfully!');
        navigation.navigate('Dashboard', { user: response.data.user });
      } else {
        Alert.alert('Verification Failed', response.data.message || 'Invalid code. Please try again.');
      }
    } catch (error) {
      console.error('Verification error:', error);
      Alert.alert(
        'Network Error',
        error.message || 'Failed to connect to server. Please check your connection.'
      );
    } finally {
      setLoading(false);
    }
  };

  const handleResendCode = async () => {
    setError('');
    setLoading(true);

    try {
      const response = await authApi.resendVerification(email);

      if (response.data.success) {
        Alert.alert('Success', 'Verification code sent to your email');
      } else {
        Alert.alert('Failed', response.data.message || 'Failed to resend code');
      }
    } catch (error) {
      console.error('Resend error:', error);
      Alert.alert('Network Error', 'Failed to resend code. Please try again later.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.scrollView}>
        <View style={styles.content}>
          <Text style={styles.title}>Verify Email</Text>
          <Text style={styles.subtitle}>
            We sent a verification code to{'\n'}
            <Text style={styles.emailText}>{email}</Text>
          </Text>

          {error && <Text style={styles.errorText}>{error}</Text>}

          <View style={styles.formGroup}>
            <Text style={styles.label}>Verification Code</Text>
            <TextInput
              style={styles.input}
              placeholder="Enter 6-character code"
              placeholderTextColor="#999"
              value={code}
              onChangeText={(text) => setCode(text.toUpperCase())}
              editable={!loading}
              maxLength={6}
            />
            <Text style={styles.helperText}>Check your email for the verification code</Text>
          </View>

          <TouchableOpacity
            style={[styles.button, loading && styles.buttonDisabled]}
            onPress={handleVerify}
            disabled={loading}
          >
            {loading ? (
              <ActivityIndicator color="white" />
            ) : (
              <Text style={styles.buttonText}>Verify Email</Text>
            )}
          </TouchableOpacity>

          <View style={styles.divider} />

          <TouchableOpacity
            onPress={handleResendCode}
            disabled={loading}
            style={styles.linkButton}
          >
            <Text style={styles.linkText}>Didn't receive the code? Resend</Text>
          </TouchableOpacity>

          <TouchableOpacity
            onPress={() => navigation.navigate('Signup')}
            disabled={loading}
            style={styles.linkButton}
          >
            <Text style={styles.linkText}>Back to Sign Up</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  scrollView: {
    flex: 1,
  },
  content: {
    flex: 1,
    justifyContent: 'center',
    paddingHorizontal: 20,
    paddingVertical: 40,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#667eea',
    marginBottom: 10,
    textAlign: 'center',
  },
  subtitle: {
    fontSize: 16,
    color: '#999',
    marginBottom: 40,
    textAlign: 'center',
    lineHeight: 24,
  },
  emailText: {
    color: '#667eea',
    fontWeight: '600',
  },
  errorText: {
    color: '#721c24',
    backgroundColor: '#f8d7da',
    padding: 12,
    borderRadius: 6,
    marginBottom: 20,
    textAlign: 'center',
    borderWidth: 1,
    borderColor: '#f5c6cb',
  },
  formGroup: {
    marginBottom: 20,
  },
  label: {
    fontSize: 14,
    fontWeight: '600',
    color: '#333',
    marginBottom: 8,
  },
  input: {
    fontSize: 18,
    fontWeight: 'bold',
    borderWidth: 2,
    borderColor: '#e0e0e0',
    borderRadius: 6,
    paddingHorizontal: 12,
    paddingVertical: 12,
    color: '#333',
    textAlign: 'center',
    letterSpacing: 2,
  },
  helperText: {
    color: '#999',
    fontSize: 12,
    marginTop: 8,
    textAlign: 'center',
  },
  button: {
    backgroundColor: '#667eea',
    paddingVertical: 14,
    borderRadius: 6,
    alignItems: 'center',
    marginTop: 10,
  },
  buttonDisabled: {
    opacity: 0.6,
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: 'bold',
  },
  divider: {
    height: 1,
    backgroundColor: '#e0e0e0',
    marginVertical: 30,
  },
  linkButton: {
    paddingVertical: 12,
    alignItems: 'center',
    marginBottom: 10,
  },
  linkText: {
    color: '#667eea',
    fontWeight: '600',
    fontSize: 14,
  },
});

export default EmailVerificationScreen;
