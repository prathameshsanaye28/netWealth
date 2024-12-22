import streamlit as st
from transformers import pipeline

# Initialize the resume review model pipeline
pipe = pipeline("text-generation", model="alfiannajih/g-retriever-resume-reviewer", trust_remote_code=True)

# Streamlit App Title
st.title("Resume Analyzer")

# Upload Resume Section
st.header("Upload Your Resume")
uploaded_file = st.file_uploader("Choose a resume file (text format)", type=["txt"])

# Process and Analyze the Resume
if uploaded_file is not None:
    # Read the file content
    resume_text = uploaded_file.read().decode("utf-8")
    
    # Display the resume content (optional)
    st.subheader("Resume Content")
    st.write(resume_text)

    # Prepare the message in the format expected by the pipeline
    messages = [
        {"role": "user", "content": resume_text},
    ]

    # Get the model output
    response = pipe(messages)
    
    # Display the analysis results
    st.subheader("Resume Analysis")
    st.write(response[0]['generated_text'])

# Display information about the app
st.sidebar.header("About the App")
st.sidebar.text("This app uses the `g-retriever-resume-reviewer` model to analyze resumes and generate feedback.")