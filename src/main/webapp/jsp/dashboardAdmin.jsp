<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session == null || session.getAttribute("user") == null){
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Accueil</title>
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
            padding: 20px;
        }

        .dashboard-wrapper {
            max-width: 1200px;
            margin: 0 auto;
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .top-bar {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 25px 35px;
            margin-bottom: 30px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 2px solid rgba(255, 255, 255, 0.8);
        }

        .welcome-section {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-avatar {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: #6b5b95;
            box-shadow: 0 4px 15px rgba(224, 195, 252, 0.4);
        }

        .welcome-text h2 {
            font-size: 24px;
            color: #6b5b95;
            margin-bottom: 5px;
        }

        .welcome-text p {
            font-size: 14px;
            color: #a393c9;
        }

        .logout-btn {
            padding: 12px 25px;
            background: white;
            color: #d64d6d;
            border: 2px solid #ffb3c6;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .logout-btn:hover {
            background: #ffe0e6;
            border-color: #d64d6d;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 179, 198, 0.3);
        }

        .main-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .dashboard-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 35px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            border: 2px solid rgba(255, 255, 255, 0.8);
            transition: all 0.3s ease;
            cursor: pointer;
            display: block;
            position: relative;
            overflow: hidden;
        }

        .dashboard-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
        }

        .dashboard-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 50px rgba(224, 195, 252, 0.3);
        }

        .card-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: #6b5b95;
            margin-bottom: 20px;
            box-shadow: 0 8px 20px rgba(224, 195, 252, 0.3);
        }

        .card-content h3 {
            font-size: 20px;
            color: #6b5b95;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .card-content p {
            font-size: 14px;
            color: #a393c9;
            line-height: 1.6;
        }

        .card-arrow {
            position: absolute;
            bottom: 20px;
            right: 25px;
            font-size: 24px;
            color: #e0c3fc;
            transition: all 0.3s ease;
        }

        .dashboard-card:hover .card-arrow {
            color: #b8a4e8;
            transform: translateX(5px);
        }

        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.06);
            border: 2px solid rgba(255, 255, 255, 0.8);
        }

        .stat-icon {
            font-size: 28px;
            margin-bottom: 12px;
        }

        .stat-card.books .stat-icon { color: #8b7ba8; }
        .stat-card.students .stat-icon { color: #a393c9; }
        .stat-card.teachers .stat-icon { color: #b8a4e8; }

        .stat-card h4 {
            font-size: 16px;
            color: #6b5b95;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .top-bar {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }

            .welcome-section {
                flex-direction: column;
            }

            .main-content {
                grid-template-columns: 1fr;
            }

            .stats-section {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-wrapper">
        <div class="top-bar">
            <div class="welcome-section">
                <div class="user-avatar">
                    <i class="fas fa-user-shield"></i>
                </div>
                <div class="welcome-text">
                    <h2>Bienvenue, <%= session.getAttribute("user") %> !</h2>
                    <p>Panneau d'administration - Système de gestion de bibliothèque</p>
                </div>
            </div>
            <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i>
                Se déconnecter
            </a>
        </div>

        <div class="main-content">
            <div class="dashboard-card" onclick="window.location.href='<%= request.getContextPath() %>/LivreServlet'">
                <div class="card-icon">
                    <i class="fas fa-book"></i>
                </div>
                <div class="card-content">
                    <h3>Gérer les livres</h3>
                    <p>Ajouter, modifier et supprimer les livres de la bibliothèque</p>
                </div>
                <i class="fas fa-arrow-right card-arrow"></i>
            </div>

            <div class="dashboard-card" onclick="window.location.href='<%= request.getContextPath() %>/EtudiantServlet'">
                <div class="card-icon">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div class="card-content">
                    <h3>Gérer les étudiants</h3>
                    <p>Administrer les comptes et informations des étudiants</p>
                </div>
                <i class="fas fa-arrow-right card-arrow"></i>
            </div>

            <div class="dashboard-card" onclick="window.location.href='<%= request.getContextPath() %>/EnseignantServlet'">
                <div class="card-icon">
                    <i class="fas fa-chalkboard-teacher"></i>
                </div>
                <div class="card-content">
                    <h3>Gérer les enseignants</h3>
                    <p>Administrer les profils et données des enseignants</p>
                </div>
                <i class="fas fa-arrow-right card-arrow"></i>
            </div>
        </div>

        <div class="stats-section">
            <div class="stat-card books">
                <div class="stat-icon">
                    <i class="fas fa-book-open"></i>
                </div>
                <h4>Bibliothèque</h4>
            </div>

            <div class="stat-card students">
                <div class="stat-icon">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <h4>Étudiants</h4>
            </div>

            <div class="stat-card teachers">
                <div class="stat-icon">
                    <i class="fas fa-user-tie"></i>
                </div>
                <h4>Enseignants</h4>
            </div>
        </div>
    </div>
</body>
</html>