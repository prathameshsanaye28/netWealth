# # from flask import Flask, request, jsonify
# # from transformers import pipeline
# # from sklearn.metrics.pairwise import cosine_similarity
# # import numpy as np

# # app = Flask(__name__)


# # # Load BERT models
# # text_classifier = pipeline("text-classification", model="bert-base-uncased")
# # embedding_model = pipeline("feature-extraction", model="bert-base-uncased", return_tensors=True)

# # @app.route('/analyze', methods=['POST'])
# # def analyze_text():
# #     data = request.json
# #     posts = data.get("posts", [])

# #     results = []
# #     for post in posts:
# #         sentiment = text_classifier(post)[0]
# #         embedding = embedding_model(post)[0]
# #         embedding_vector = np.mean(embedding, axis=0).tolist()
# #         results.append({
# #             "post": post,
# #             "sentiment": sentiment,
# #             "embedding": embedding_vector,
# #         })

# #     return jsonify({"results": results})

# # @app.route('/compare', methods=['POST'])
# # def compare_embeddings():
# #     data = request.json
# #     embedding1 = np.array(data.get("embedding1", []))
# #     embedding2 = np.array(data.get("embedding2", []))

# #     similarity = cosine_similarity([embedding1], [embedding2])[0][0]
# #     return jsonify({"similarity": similarity})

# # if __name__ == '__main__':
# #     app.run(debug=True)



# from transformers import BertTokenizer, BertModel
# import torch

# class NLPModel:
#     def __init__(self):
#         # Load pre-trained BERT model and tokenizer
#         self.tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
#         self.model = BertModel.from_pretrained('bert-base-uncased')

#     def encode_text(self, text: str):
#         # Tokenize and get BERT embeddings
#         inputs = self.tokenizer(text, return_tensors='pt', truncation=True, padding=True, max_length=512)
#         with torch.no_grad():
#             outputs = self.model(**inputs)
#         return outputs.last_hidden_state.mean(dim=1)  # Use mean pooling for sentence embedding

#     def get_similarity(self, text1: str, text2: str):
#         # Compute cosine similarity between two texts
#         emb1 = self.encode_text(text1)
#         emb2 = self.encode_text(text2)
#         cos_sim = torch.nn.functional.cosine_similarity(emb1, emb2)
#         return cos_sim.item()
    
# import numpy as np

# class PostMatcher:
#     def __init__(self, nlp_model):
#         self.nlp_model = nlp_model

#     def match_users(self, posts, target_user):
#         # Match target_user with other users based on post description similarity
#         similarities = []
#         for post in posts:
#             if post['uid'] != target_user['uid']:
#                 similarity = self.nlp_model.get_similarity(target_user['description'], post['description'])
#                 similarities.append((post['uid'], similarity))
#         similarities.sort(key=lambda x: x[1], reverse=True)  # Sort by similarity
#         return similarities[:5]  # Return top 5 matching users

#     def suggest_jobs(self, posts, jobs):
#         # Suggest jobs based on post similarity
#         suggestions = []
#         for job in jobs:
#             job_description = job['description']
#             for post in posts:
#                 similarity = self.nlp_model.get_similarity(post['description'], job_description)
#                 if similarity > 0.7:  # Consider similarity threshold
#                     suggestions.append(job)
#                     break
#         return suggestions
    
# from flask import Flask, request, jsonify

# app = Flask(__name__)

# # Initialize NLP model and matcher
# nlp_model = NLPModel()
# post_matcher = PostMatcher(nlp_model)

# # Dummy data for testing
# posts = [
#     {'uid': 'user1', 'description': 'Looking for a software developer role in AI and ML.'},
#     {'uid': 'user2', 'description': 'Expert in full stack development, seeking new challenges.'},
#     {'uid': 'user3', 'description': 'AI enthusiast with experience in deep learning and NLP.'},
# ]

# jobs = [
#     {'id': 'job1', 'title': 'Software Engineer', 'description': 'Looking for someone with experience in AI and machine learning.'},
#     {'id': 'job2', 'title': 'Full Stack Developer', 'description': 'Required skills in backend and frontend development.'},
#     {'id': 'job3', 'title': 'Data Scientist', 'description': 'Experience in NLP and deep learning required.'},
# ]

# @app.route('/match_users', methods=['POST'])
# def match_users():
#     target_user = request.json  # JSON body should include target user data
#     matched_users = post_matcher.match_users(posts, target_user)
#     return jsonify(matched_users)

# @app.route('/suggest_jobs', methods=['POST'])
# def suggest_jobs():
#     user_posts = request.json  # JSON body should include user posts data
#     suggested_jobs = post_matcher.suggest_jobs(user_posts, jobs)
#     return jsonify(suggested_jobs)

# if __name__ == '__main__':
#     app.run(debug=True)

from flask import Flask, request, jsonify
from transformers import BertTokenizer, BertModel
import torch
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for cross-origin requests

# Load pre-trained BERT model and tokenizer
tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
model = BertModel.from_pretrained('bert-base-uncased')

# Function to encode text to BERT embeddings
def get_bert_embeddings(text):
    inputs = tokenizer(text, return_tensors="pt", truncation=True, padding=True, max_length=512)
    with torch.no_grad():
        outputs = model(**inputs)
    embeddings = outputs.last_hidden_state.mean(dim=1)  # Use the mean of token embeddings
    return embeddings

# Endpoint for matching users based on post content
@app.route('/match_users', methods=['POST'])
def match_users():
    target_user = request.json  # Receive the target user's post
    target_description = target_user.get('description', '')
    
    # Placeholder for other users' posts, you should get this data from your Firebase database
    other_posts = [
        {"uid": "user1", "description": "Looking for a job in data science."},
        {"uid": "user2", "description": "I love programming in Flutter."},
        {"uid": "user3", "description": "Searching for AI-related work."},
        {"uid": "user4", "description": "Building mobile apps in my free time."},
    ]
    
    # Extract descriptions of other users
    descriptions = [post['description'] for post in other_posts]

    # Get the embedding for the target user's description
    target_embedding = get_bert_embeddings(target_description)
    
    # Get the embeddings for the descriptions of other users
    other_embeddings = [get_bert_embeddings(desc) for desc in descriptions]
    
    # Calculate cosine similarities between the target user and other users
    similarities = []
    for idx, embedding in enumerate(other_embeddings):
        similarity = cosine_similarity(target_embedding.numpy(), embedding.numpy())
        similarities.append({"uid": other_posts[idx]['uid'], "similarity": float(similarity[0][0])})
    
    # Sort users based on similarity (descending order)
    sorted_users = sorted(similarities, key=lambda x: x['similarity'], reverse=True)
    
    return jsonify(sorted_users)  # Return sorted list of users

# Endpoint for suggesting jobs based on user posts
@app.route('/suggest_jobs', methods=['POST'])
def suggest_jobs():
    posts = request.json  # Receive posts from users
    
    # Placeholder for job postings (in reality, fetch from your database)
    job_postings = [
        {"title": "Data Scientist", "description": "Looking for someone with experience in machine learning and AI."},
        {"title": "Flutter Developer", "description": "We need a Flutter developer for our new mobile project."},
        {"title": "AI Engineer", "description": "Experience with deep learning and neural networks is required."},
        {"title": "Mobile App Developer", "description": "We need a developer skilled in mobile app development."},
    ]
    
    # Extract job descriptions
    job_descriptions = [job['description'] for job in job_postings]

    job_embeddings = [get_bert_embeddings(desc) for desc in job_descriptions]
    user_embeddings = [get_bert_embeddings(post['description']) for post in posts]

    job_suggestions = []

    # For each user's post, compare it with all job descriptions
    for user_post, user_embedding in zip(posts, user_embeddings):
        similarities = []
        for idx, job_embedding in enumerate(job_embeddings):
            similarity = cosine_similarity(user_embedding.numpy(), job_embedding.numpy())
            similarities.append({"uid": user_post['uid'], "similarity": float(similarity[0][0])})
        
        # Sort jobs based on similarity to this user's post
        sorted_jobs = sorted(similarities, key=lambda x: x['similarity'], reverse=True)
        job_suggestions.append({"user": user_post['uid'], "suggested_jobs": sorted_jobs})
    
    return jsonify(job_suggestions)  # Return job suggestions for each user

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)