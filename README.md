# Blog API

Cette API Rails sert de backend pour notre application de blog.

## Configuration requise

- Ruby version: 3.2.2
- Rails version: 8.0.1
- Base de données: PostgreSQL

## Installation

1. Cloner le repository

```bash
git clone <votre-repo>
cd blog_api
```

2. Installer les dépendances

```bash
bundle install
```

3. Configuration de la base de données

```bash
rails db:create
rails db:migrate
```

4. Lancer le serveur

```bash
rails s -p 3001
```

## Points d'API

### Authentification

- POST `/signup` - Inscription d'un nouvel utilisateur
- POST `/login` - Connexion d'un utilisateur
- DELETE `/logout` - Déconnexion

### Articles

- GET `/api/v1/articles` - Liste tous les articles
- GET `/api/v1/articles/:id` - Affiche un article spécifique
- POST `/api/v1/articles` - Crée un nouvel article
- PUT `/api/v1/articles/:id` - Modifie un article
- DELETE `/api/v1/articles/:id` - Supprime un article

## Structure de la base de données

### Users

- email (string)
- encrypted_password (string)
- autres champs Devise

### Articles

- title (string)
- content (text)
- user_id (references)
- created_at (datetime)
- updated_at (datetime)

## Sécurité

L'API utilise :

- JWT pour l'authentification
- Devise pour la gestion des utilisateurs
- CORS configuré pour accepter les requêtes du frontend

## Tests

Pour lancer les tests :

```bash
rails test
```

## Déploiement

Instructions pour le déploiement à venir...

## Contribution

1. Forker le projet
2. Créer une branche (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commiter vos changements (`git commit -am 'Ajout d'une nouvelle fonctionnalité'`)
4. Pusher vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Créer une Pull Request

## Communication API

### Architecture de l'API

L'API suit une architecture REST et communique en JSON. Elle utilise :

- JWT (JSON Web Tokens) pour l'authentification
- Le format de réponse standardisé : `{ status: "success", data: [...] }`
- Les codes HTTP standards (200, 201, 401, 404, etc.)

### Format des Réponses

1. **Authentification** :

```json
// POST /login - Réponse
{
  "token": "jwt_token_here",
  "user": {
    "id": 1,
    "email": "user@example.com"
  }
}
```

2. **Articles** :

```json
// GET /api/v1/articles - Réponse
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "title": "Titre",
      "content": "Contenu",
      "user_id": 1,
      "created_at": "2024-03-05T..."
    }
  ]
}
```

### Sécurité et Headers

Pour les requêtes authentifiées, le frontend doit inclure :

```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

### CORS

L'API est configurée pour accepter les requêtes de `http://localhost:3000` avec :

- Headers autorisés : `Authorization`, `Content-Type`
- Méthodes autorisées : `GET`, `POST`, `PUT`, `DELETE`

## Tester l'API avec curl

Voici les commandes pour tester les différentes fonctionnalités de l'API :

### Authentification

```bash
# Inscription (Register)
curl -X POST http://localhost:3001/signup \
-H "Content-Type: application/json" \
-d '{"user": {"email": "test@example.com", "password": "password123", "password_confirmation": "password123"}}'

# Connexion (Login)
curl -X POST http://localhost:3001/login \
-H "Content-Type: application/json" \
-d '{"user": {"email": "test@example.com", "password": "password123"}}' \
-v
```

### Articles

```bash
# Voir tous les articles (sans authentification)
curl http://localhost:3001/api/v1/articles

# Voir un article spécifique (sans authentification)
curl http://localhost:3001/api/v1/articles/1

# Créer un article (avec authentification)
curl -X POST http://localhost:3001/api/v1/articles \
-H "Authorization: Bearer VOTRE_TOKEN_JWT" \
-H "Content-Type: application/json" \
-d '{"article": {"title": "Mon Article", "content": "Contenu de mon article"}}'

# Modifier un article (avec authentification)
curl -X PUT http://localhost:3001/api/v1/articles/1 \
-H "Authorization: Bearer VOTRE_TOKEN_JWT" \
-H "Content-Type: application/json" \
-d '{"article": {"title": "Titre modifié", "content": "Contenu modifié"}}'

# Supprimer un article (avec authentification)
curl -X DELETE http://localhost:3001/api/v1/articles/1 \
-H "Authorization: Bearer VOTRE_TOKEN_JWT"
```

### Vérification du Token

```bash
# Vérifier si le token est valide
curl http://localhost:3001/api/v1/articles \
-H "Authorization: Bearer VOTRE_TOKEN_JWT" \
-v
```

**Note** : Remplacez `VOTRE_TOKEN_JWT` par le token reçu lors de la connexion.
