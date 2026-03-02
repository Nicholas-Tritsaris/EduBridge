// Android Login & Signup Page
import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import axios from 'axios';

const AuthScreen = () => {
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [verificationCode, setVerificationCode] = useState('');
  const [isVerifying, setIsVerifying] = useState(false);

  const handleSignup = async () => {
    if (password !== confirmPassword) {
      Alert.alert('Error', 'Passwords do not match');
      return;
    }
    try {
      const response = await axios.post('http://localhost:5000/api/auth/signup', {
        email,
        password,
      });
      Alert.alert('Success', 'Verification email sent. Please check your inbox.');
      setIsVerifying(true);
    } catch (error) {
      Alert.alert('Error', error.response?.data?.message || 'Signup failed');
    }
  };

  const handleLogin = async () => {
    try {
      const response = await axios.post('http://localhost:5000/api/auth/login', {
        email,
        password,
      });
      Alert.alert('Success', 'Logged in successfully');
      // Navigate to dashboard
    } catch (error) {
      Alert.alert('Error', error.response?.data?.message || 'Login failed');
    }
  };

  const handleVerifyEmail = async () => {
    try {
      const response = await axios.post('http://localhost:5000/api/auth/verify-email', {
        email,
        code: verificationCode,
      });
      Alert.alert('Success', 'Email verified! You can now log in.');
      setIsLogin(true);
      setIsVerifying(false);
    } catch (error) {
      Alert.alert('Error', error.response?.data?.message || 'Verification failed');
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>EduBridge</Text>
      
      {!isVerifying ? (
        <>
          <TextInput
            style={styles.input}
            placeholder="Email"
            keyboardType="email-address"
            value={email}
            onChangeText={setEmail}
          />
          <TextInput
            style={styles.input}
            placeholder="Password"
            secureTextEntry
            value={password}
            onChangeText={setPassword}
          />
          
          {!isLogin && (
            <TextInput
              style={styles.input}
              placeholder="Confirm Password"
              secureTextEntry
              value={confirmPassword}
              onChangeText={setConfirmPassword}
            />
          )}
          
          <TouchableOpacity
            style={styles.button}
            onPress={isLogin ? handleLogin : handleSignup}
          >
            <Text style={styles.buttonText}>
              {isLogin ? 'Login' : 'Sign Up'}
            </Text>
          </TouchableOpacity>
          
          <TouchableOpacity onPress={() => setIsLogin(!isLogin)}>
            <Text style={styles.toggleText}>
              {isLogin ? 'Don\'t have an account? Sign Up' : 'Already have an account? Login'}
            </Text>
          </TouchableOpacity>
        </>
      ) : (
        <>
          <Text style={styles.verificationText}>
            Enter the verification code sent to {email}
          </Text>
          <TextInput
            style={styles.input}
            placeholder="Verification Code"
            value={verificationCode}
            onChangeText={setVerificationCode}
          />
          <TouchableOpacity style={styles.button} onPress={handleVerifyEmail}>
            <Text style={styles.buttonText}>Verify Email</Text>
          </TouchableOpacity>
        </>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    justifyContent: 'center',
    backgroundColor: '#f5f5f5',
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 30,
    color: '#333',
  },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    padding: 12,
    marginBottom: 15,
    borderRadius: 8,
    backgroundColor: '#fff',
  },
  button: {
    backgroundColor: '#007AFF',
    padding: 12,
    borderRadius: 8,
    alignItems: 'center',
    marginTop: 20,
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
  toggleText: {
    textAlign: 'center',
    color: '#007AFF',
    marginTop: 15,
  },
  verificationText: {
    textAlign: 'center',
    marginBottom: 20,
    color: '#333',
  },
});

export default AuthScreen;