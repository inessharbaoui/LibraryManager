<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion - Bibliothèque</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ffd6e8 0%, #e0c3fc 50%, #c3e0fc 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 420px;
            width: 100%;
            animation: slideUp 0.5s ease-out;
            border: 2px solid rgba(255, 255, 255, 0.8);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            background: linear-gradient(135deg, #ffd6e8 0%, #e0c3fc 100%);
            padding: 45px 30px;
            text-align: center;
            color: #6b5b95;
        }

        .book-icon {
            font-size: 56px;
            margin-bottom: 15px;
            color: #a393c9;
        }

        .login-header h2 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
            color: #6b5b95;
        }

        .login-header p {
            font-size: 14px;
            opacity: 0.85;
            color: #8b7ba8;
        }

        .login-form {
            padding: 40px 30px;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            color: #6b5b95;
            font-weight: 500;
            font-size: 14px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #a393c9;
            font-size: 16px;
        }

        .form-group input {
            width: 100%;
            padding: 14px 15px 14px 45px;
            border: 2px solid #e0c3fc;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #faf8ff;
            color: #6b5b95;
        }

        .form-group input::placeholder {
            color: #c3b3e0;
        }

        .form-group input:focus {
            outline: none;
            border-color: #b8a4e8;
            background: white;
            box-shadow: 0 0 0 4px rgba(184, 164, 232, 0.15);
        }

        .form-group input:focus + .input-icon {
            color: #8b7ba8;
        }

        .submit-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
            color: #6b5b95;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(224, 195, 252, 0.4);
            background: linear-gradient(135deg, #d4b3f0 0%, #ffcce0 100%);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .error-message {
            background: #ffe0e6;
            color: #d64d6d;
            padding: 14px 15px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 4px solid #ffb3c6;
            animation: shake 0.5s ease;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }

        .divider {
            text-align: center;
            margin: 25px 0;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            width: 100%;
            height: 1px;
            background: #e0c3fc;
        }

        .divider span {
            background: rgba(255, 255, 255, 0.95);
            padding: 0 15px;
            color: #a393c9;
            font-size: 13px;
            position: relative;
            z-index: 1;
        }

        .signup-link {
            text-align: center;
            margin-top: 20px;
        }

        .signup-btn {
            width: 100%;
            padding: 15px;
            background: white;
            color: #6b5b95;
            border: 2px solid #e0c3fc;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
        }

        .signup-btn:hover {
            background: #faf8ff;
            border-color: #b8a4e8;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(224, 195, 252, 0.3);
        }

        .footer-text {
            text-align: center;
            margin-top: 25px;
            font-size: 13px;
            color: #a393c9;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        @media (max-width: 480px) {
            .login-container {
                margin: 10px;
            }
            
            .login-form {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <div class="book-icon">
                <i class="fas fa-book-open"></i>
            </div>
            <h2>Bibliothèque</h2>
            <p>Connectez-vous à votre compte</p>
        </div>

        <div class="login-form">
            <%
                if(request.getParameter("error") != null) {
                    out.println("<div class='error-message'><i class='fas fa-exclamation-circle'></i> Login ou mot de passe incorrect</div>");
                }
            %>

            <form action="<%= request.getContextPath() %>/LoginServlet" method="post">
                <div class="form-group">
                    <label for="login"><i class="fas fa-user"></i> Login</label>
                    <div class="input-wrapper">
                        <input type="text" id="login" name="login" required placeholder="Entrez votre login" />
                        <i class="fas fa-user input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="pass"><i class="fas fa-lock"></i> Mot de passe</label>
                    <div class="input-wrapper">
                        <input type="password" id="pass" name="pass" required placeholder="Entrez votre mot de passe" />
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fas fa-sign-in-alt"></i>
                    Se connecter
                </button>
            </form>

            <div class="divider">
                <span>ou</span>
            </div>

            <div class="signup-link">
                <a href="<%= request.getContextPath() %>/jsp/inscription.jsp" class="signup-btn">
                    <i class="fas fa-user-plus"></i>
                    Créer un compte
                </a>
            </div>

            <p class="footer-text">
                <i class="fas fa-bookmark"></i>
                Système de gestion de bibliothèque
            </p>
        </div>
    </div>
</body>
</html>