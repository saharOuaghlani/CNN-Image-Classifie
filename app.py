import tensorflow as tf
from flask import Flask, request, jsonify
from tensorflow.keras.preprocessing import image
import numpy as np
from sklearn.metrics import confusion_matrix

app = Flask(__name__)
app.config.update(dict(
    DEBUG=True,
    MAIL_SERVER='localhost',
    MAIL_USE_TLS=False,
    MAIL_USE_SSL=False,
    MAIL_USERNAME=None,
    MAIL_PASSWORD=None,
))

# Load the trained model
model = tf.keras.models.load_model('CNN.h5')

# Resize the input  images
target_size = (256, 256)
def preprocess_image(img_path):
    img = image.load_img(img_path, target_size=target_size)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array /= 255.0  # Normalize pixel values to be between 0 and 1
    return img_array

def generate_confusion_matrix(model, data_generator):
    # Get predictions on the validation set
    y_pred = model.predict(data_generator)
    y_true = data_generator.classes

    # Generate a confusion matrix
    conf_matrix = confusion_matrix(y_true, y_pred.argmax(axis=1))

    return conf_matrix
class_labels = {0:'COVID', 1: 'NORMAL', 2:'PNEUMONIA'}


@app.route('/api/predict', methods=['POST'])
def predict():
    file = request.files.get('file')    
    print(request.data)

    if file== None:
        return jsonify({'error': 'No selected file'})
# Save the uploaded image temporarily
    if file:
        img_path = "temp/temp.jpg"  
        file.save(img_path)

        # Preprocess the image
        img_array = preprocess_image(img_path)

        # Make prediction
        prediction = model.predict(img_array)

        # Get the predicted class label
        predicted_class = np.argmax(prediction, axis=1)[0]
        class_name = class_labels[predicted_class]

        return jsonify({'class_name': class_name, 'prediction': float(prediction[0][predicted_class])})

@app.route('/api/confusion_matrix', methods=['GET'])
def get_confusion_matrix():
    conf_matrix = generate_confusion_matrix(model, test_generator)
    return jsonify({'confusion_matrix': conf_matrix.tolist()})


if __name__ == '__main__':
    app.run(debug=True)

