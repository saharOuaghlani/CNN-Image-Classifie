import tensorflow as tf
from flask import Flask, request, jsonify
from tensorflow.keras.preprocessing import image
import numpy as np
from sklearn.metrics import classification_report, confusion_matrix
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import pickle


app = Flask(__name__)
app.config.update(dict(
    DEBUG=True,
    MAIL_SERVER='localhost',
    MAIL_USE_TLS=False,
    MAIL_USE_SSL=False,
    MAIL_USERNAME=None,
    MAIL_PASSWORD=None,
))
class_labels = {0:'COVID', 1: 'NORMAL', 2:'PNEUMONIA'}

# Load the trained model
model = tf.keras.models.load_model('CNN.h5')

# Load the information to recreate the generator
with open('test_generator_info.pkl', 'rb') as file:
    test_generator_info = pickle.load(file)

# Function to recreate the generator
def recreate_test_generator():
    datagen = ImageDataGenerator(
        rescale=1./255,
        shear_range=0.2,
        zoom_range=0.2,
        horizontal_flip=False,
        validation_split=0.2,
    )
    return datagen.flow_from_directory(**test_generator_info)

# Resize the input  images
target_size = (256, 256)
def preprocess_image(img_path):
    img = image.load_img(img_path, target_size=target_size)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array /= 255.0  # Normalize pixel values to be between 0 and 1
    return img_array

def generate_confusion_matrix(model, test_generator):
    # Get predictions on the test set
    y_pred = model.predict(test_generator)
    # Get true labels from the test generator
    y_true = test_generator.labels
    # Generate a confusion matrix
    conf_matrix = confusion_matrix(y_true, y_pred.argmax(axis=1))
    return conf_matrix

@app.route('/api/predict', methods=['POST'])
def predict():
    file = request.files.get('file')    
    print(request.data)

    if file== None:
        return jsonify({'error': 'No selected file'})
# Save the uploaded image temporarily
    if file :
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

@app.route('/api/infos', methods=['GET'])
def get_info():
    # Recreate the test generator
    test_generator = recreate_test_generator()
    # Generate confusion matrix and classification report
    conf_matrix = generate_confusion_matrix(model, test_generator)
    # Evaluate the model on the validation set
    validation_loss, validation_accuracy = model.evaluate(test_generator)
    
    # Additional code to get validation metrics
    validation_metrics = {
        'validation_accuracy': validation_accuracy,
        'validation_loss': validation_loss,
        'confusion_matrix': conf_matrix.tolist(),  
    }

    return jsonify(validation_metrics)
    
if __name__ == '__main__':
    app.config['TIMEOUT'] = 360  
    app.run(debug=False, host='0.0.0.0')