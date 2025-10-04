import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ForgotPasswordScreen.dart';

class AuthPage extends StatefulWidget {
  final bool isSignUp;

  const AuthPage({
    super.key,
    this.isSignUp = false,
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login controllers
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  // Signup controllers
  final TextEditingController _signupNameController = TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController = TextEditingController();
  final TextEditingController _signupConfirmPasswordController = TextEditingController();
  final TextEditingController _signupPhoneController = TextEditingController();

  bool _isLoginPasswordVisible = false;
  bool _isSignupPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.isSignUp ? 1 : 0,
    );
  }


  Future<void> addUser({
    required String name,
    required String email,
    required int age,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'email': email,
        'age': age,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ User added successfully!');
    } catch (e) {
      print('❌ Error adding user: $e');
    }
  }





  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    _signupPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {

    addUser(name: "Adam", email: "adam@example.com", age: 9);


    if (_loginEmailController.text.isEmpty || _loginPasswordController.text.isEmpty) {
      _showErrorDialog('נא למלא את כל השדות');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _loginEmailController.text.trim(),
        password: _loginPasswordController.text,
      );

      // Get user data from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog('התחברת בהצלחה! ברוך הבא ${userDoc['name']}');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String errorMessage = 'שגיאה בהתחברות';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'המשתמש לא נמצא';
          break;
        case 'wrong-password':
          errorMessage = 'סיסמה שגויה';
          break;
        case 'invalid-email':
          errorMessage = 'כתובת אימייל לא תקינה';
          break;
        case 'user-disabled':
          errorMessage = 'חשבון זה הושבת';
          break;
        case 'too-many-requests':
          errorMessage = 'יותר מדי ניסיונות. נסה שוב מאוחר יותר';
          break;
        default:
          errorMessage = 'שגיאה: ${e.message}';
      }

      _showErrorDialog(errorMessage);
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('שגיאה: ${e.toString()}');
    }
  }




  Future<void> _handleSignup() async {
    if (_signupNameController.text.isEmpty ||
        _signupEmailController.text.isEmpty ||
        _signupPasswordController.text.isEmpty ||
        _signupConfirmPasswordController.text.isEmpty) {
      _showErrorDialog('נא למלא את כל השדות');
      return;
    }

    if (_signupPasswordController.text != _signupConfirmPasswordController.text) {
      _showErrorDialog('הסיסמאות אינן תואמות');
      return;
    }

    if (_signupPasswordController.text.length < 6) {
      _showErrorDialog('הסיסמה חייבת להכיל לפחות 6 תווים');
      return;
    }

    if (!_agreeToTerms) {
      _showErrorDialog('נא לאשר את תנאי השימוש');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create user with Firebase Auth
      // UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      //   email: _signupEmailController.text.trim(),
      //   password: _signupPasswordController.text,
      // );

      // Save user data to Firestore
      // await _firestore.collection('users').doc(userCredential.user!.uid).set({
      await FirebaseFirestore.instance.collection('users').add({
      // 'uid': userCredential.user!.uid,
        'name': _signupNameController.text.trim(),
        'email': _signupEmailController.text.trim(),
        'phone': _signupPhoneController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'ratings': [], // Array to store user's ratings
        'favorites': [], // Array to store favorite destinations
        'profileImageUrl': '', // Placeholder for profile image
      });

      // Update display name
      // await userCredential.user!.updateDisplayName(_signupNameController.text.trim());

      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog('נרשמת בהצלחה! ברוך הבא ${_signupNameController.text}');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String errorMessage = 'שגיאה בהרשמה';

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'הסיסמה חלשה מדי';
          break;
        case 'email-already-in-use':
          errorMessage = 'האימייל כבר קיים במערכת';
          break;
        case 'invalid-email':
          errorMessage = 'כתובת אימייל לא תקינה';
          break;
        case 'operation-not-allowed':
          errorMessage = 'פעולה זו אינה מאושרת';
          break;
        default:
          errorMessage = 'שגיאה: ${e.message}';
      }

      _showErrorDialog(errorMessage);
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('שגיאה: ${e.toString()}');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    // TODO: Implement Google Sign In
    // You'll need google_sign_in package
    _showErrorDialog('Google Sign In - coming soon');
  }

  Future<void> _handleFacebookSignIn() async {
    // TODO: Implement Facebook Sign In
    // You'll need flutter_facebook_auth package
    _showErrorDialog('Facebook Sign In - coming soon');
  }

  Future<void> _handleAppleSignIn() async {
    // TODO: Implement Apple Sign In
    // You'll need sign_in_with_apple package
    _showErrorDialog('Apple Sign In - coming soon');
  }

  Future<void> _handlePasswordReset() async {
    if (_loginEmailController.text.isEmpty) {
      _showErrorDialog('נא להזין את כתובת האימייל שלך');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(
        email: _loginEmailController.text.trim(),
      );
      _showSuccessDialog('נשלח קישור לאיפוס סיסמה לאימייל שלך');
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'שגיאה בשליחת קישור לאיפוס סיסמה';

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'כתובת אימייל לא תקינה';
          break;
        case 'user-not-found':
          errorMessage = 'משתמש לא נמצא';
          break;
        default:
          errorMessage = 'שגיאה: ${e.message}';
      }

      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 10),
            Text('שגיאה'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('אישור'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('הצלחה'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('אישור'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF26A69A),
              Color(0xFF00796B),
              Color(0xFF004D40),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'PATHY',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Content Card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      // Tab Bar
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF26A69A), Color(0xFF00796B)],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey[700],
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: const [
                            Tab(text: 'התחברות'),
                            Tab(text: 'הרשמה'),
                          ],
                        ),
                      ),

                      // Tab Views
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildLoginTab(),
                            _buildSignupTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Text(
            'ברוכים השבים!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00796B),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'התחבר כדי להמשיך',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),

          // Email Field
          _buildTextField(
            controller: _loginEmailController,
            label: 'אימייל',
            hint: 'הכנס את האימייל שלך',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          // Password Field
          _buildTextField(
            controller: _loginPasswordController,
            label: 'סיסמה',
            hint: 'הכנס את הסיסמה שלך',
            icon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isLoginPasswordVisible,
            onTogglePassword: () {
              setState(() => _isLoginPasswordVisible = !_isLoginPasswordVisible);
            },
          ),
          const SizedBox(height: 10),

          // Forgot Password
          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordPage(),
                  ),
                );
              },
              child: const Text(
                'שכחת סיסמה?',
                style: TextStyle(color: Color(0xFF00796B)),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Login Button
          _buildGradientButton(
            text: 'התחבר',
            onPressed: _isLoading ? null : _handleLogin,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 30),

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[400])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'או התחבר עם',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[400])),
            ],
          ),
          const SizedBox(height: 20),

          // Social Login Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                icon: Icons.g_mobiledata,
                onPressed: _handleGoogleSignIn,
              ),
              const SizedBox(width: 20),
              _buildSocialButton(
                icon: Icons.facebook,
                onPressed: _handleFacebookSignIn,
              ),
              const SizedBox(width: 20),
              _buildSocialButton(
                icon: Icons.apple,
                onPressed: _handleAppleSignIn,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignupTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Text(
            'צור חשבון חדש',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00796B),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'הרשם והתחל לגלות את ישראל',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),

          // Name Field
          _buildTextField(
            controller: _signupNameController,
            label: 'שם מלא',
            hint: 'הכנס את שמך המלא',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 20),

          // Email Field
          _buildTextField(
            controller: _signupEmailController,
            label: 'אימייל',
            hint: 'הכנס את האימייל שלך',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          // Phone Field
          _buildTextField(
            controller: _signupPhoneController,
            label: 'טלפון (אופציונלי)',
            hint: 'הכנס את מספר הטלפון שלך',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),

          // Password Field
          _buildTextField(
            controller: _signupPasswordController,
            label: 'סיסמה',
            hint: 'בחר סיסמה חזקה (לפחות 6 תווים)',
            icon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isSignupPasswordVisible,
            onTogglePassword: () {
              setState(() => _isSignupPasswordVisible = !_isSignupPasswordVisible);
            },
          ),
          const SizedBox(height: 20),

          // Confirm Password Field
          _buildTextField(
            controller: _signupConfirmPasswordController,
            label: 'אימות סיסמה',
            hint: 'הכנס את הסיסמה שוב',
            icon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isConfirmPasswordVisible,
            onTogglePassword: () {
              setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
            },
          ),
          const SizedBox(height: 20),

          // Terms and Conditions
          Row(
            children: [
              Checkbox(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() => _agreeToTerms = value ?? false);
                },
                activeColor: const Color(0xFF00796B),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _agreeToTerms = !_agreeToTerms);
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      children: [
                        const TextSpan(text: 'אני מסכים ל'),
                        TextSpan(
                          text: 'תנאי השימוש',
                          style: const TextStyle(
                            color: Color(0xFF00796B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' ו'),
                        TextSpan(
                          text: 'מדיניות הפרטיות',
                          style: const TextStyle(
                            color: Color(0xFF00796B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Signup Button
          _buildGradientButton(
            text: 'הירשם',
            onPressed: _isLoading ? null : _handleSignup,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00796B),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          keyboardType: keyboardType,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: const Color(0xFF00796B)),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
              ),
              onPressed: onTogglePassword,
            )
                : null,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF00796B), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF26A69A), Color(0xFF00796B)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF26A69A).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 30, color: Colors.grey[700]),
        onPressed: onPressed,
      ),
    );
  }
}
