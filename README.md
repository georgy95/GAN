# Keras Implementation of SRGAN
Keras and Google Cloud Ready implementation of ["Photo-Realistic Single Image Super-Resolution Using a Generative Adversarial Network"](https://arxiv.org/abs/1609.04802)

Credit to https://github.com/MathiasGruber/SRGAN-Keras


<img src='images/main_samples_with_psnr.png' width="100%" />


## 1. Architecture
The generator creates a high-resolution (HR) image (4x upscaled) from a corresponding low-resolution (LR) image. The discriminator distinguishes the generated (fake) HR images from the original HR images.

### 1.1. Generator & Discriminator
<img src='images/architecture.PNG' width="80%" />

[Figure 4 from paper](https://arxiv.org/abs/1609.04802): Architecture of Generator and Discriminator Network with corresponding kernel size (k), number of feature maps
(n) and stride (s) indicated for each convolutional layer.

### 1.2. Overview of input / outputs
<img src='images/code_setup.PNG' width="80%" />

**Code Overview**: Overview of the three networks; generator, discriminator, and VGG19. Generator create SR image from LR, discriminator predicts whether it's a SR or original HR, and VGG19 extracts features from generated SR and original HR images. 

## 2. Content & Adversarial Loss
<img src='images/loss_equations.PNG' width="80%" />

**Losses Overview**: The perceptual loss is a combination of content loss (based on VGG19 features) and adversarial loss. Equations are taken directly from ["original paper"](https://arxiv.org/abs/1609.04802).

## 3. Using this repository

### 3.1. Training
## Local
Create 2 folders `train`, `valid` in the  `trainer/data` directory and place your images there.

Use the bash file `train.sh`. To train run e.g.:
```
git clone https://github.com/skiler07/GAN.git
cd GAN
sh train.sh local
```

## Remote
See `train.sh` file for more details and specify remote `job_dir`.

### 3.2. Testing
Check the example_usage notebook: [example_usage.ipynb](./Example_Usage.ipynb)