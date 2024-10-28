# Convolutions and Content Aware Image Resizing With Seams


This project explores **convolution**, **seam carving**, and **seam adding** for image resizing and manipulation in a Pluto notebook using Julia. The notebook is designed to work within the Julia programming language and leverages Pluto.jl for interactive, reactive coding.

## Convolution

Convolution is a common technique in data processing and image manipulation, used to extract features, apply filters, and modify the dataset in various ways. 

Convolution is performed by sliding a small matrix, known as a **kernel** or **filter**, over each position in the dataset and calculating an output for each position based on the weighted combination of neighboring values. Here’s how it works:

1. **Center the Kernel**: For each value in the dataset, center the kernel on that value. The kernel values align with corresponding values in the dataset.
2. **Apply Kernel Multiplication**: Multiply each value in the kernel by the corresponding dataset value it overlaps.
3. **Sum the Results**: Sum these products to get the final output value for that position.
4. **Slide and Repeat**: Slide the kernel across the dataset, repeating the above steps for every position.

**Note**: Mathematically, the kernel is mirrored before iterating over the dataset. This mirroring is important for maintaining the proper orientation of the kernel during convolution. However, this step can often be ignored when dealing with images, as the kernel can be defined to suit the specific application directly.

### Edge Handling

When the kernel overlaps the edges of the dataset, parts of it may extend beyond the boundaries. Instead of filling these areas with zeros, this project uses the **geometrically closest value** to handle these edge cases. This ensures that the convolution operation at the edges is smoother and more consistent with the surrounding data, as it utilizes the nearest valid data point rather than arbitrary zeros.

### Example Kernels and Their Effects

Different kernels yield different transformations:

- **Average/Blur Kernel**: A kernel with uniform values that sum to 1 creates a local average of values around each point, producing a *blurring effect*. 

    Example:
    ```
    [ 1/9 1/9 1/9 ]
    [ 1/9 1/9 1/9 ]
    [ 1/9 1/9 1/9 ]
    ```

- **Sharpening Kernel**: A sharpening kernel emphasizes the center value relative to its neighbors, highlighting edges and details in the dataset.

    Example:
    ```
    [ -0.5  -1  -0.5 ]
    [  -1    8   -1  ]
    [ -0.5  -1  -0.5 ]
    ```

- **Gaussian Kernel**: This kernel uses a weighted average based on the Gaussian distribution, where central values have more weight than peripheral values, resulting in a smoother, natural blur.

    Example:
    ```
    1/256 * [ 1   4   6   4   1 ]
            [ 4  16  24  16   4 ]
            [ 6  24  36  24   6 ]
            [ 4  16  24  16   4 ]
            [ 1   4   6   4   1 ]
    ```

- **Sobel Kernels**: The sobel kernels detect changes in brightness in the direction of the sobel filter. This can be used to detect edges in an image.

  Sobel Y:
  ```
    [ -0.125   -0.25   -0.125 ]
    [    0        0       0   ]
    [  0.125    0.25    0.125 ]
  ```
  Sobel X:
  ```
    [ -0.125   0   0.125 ]
    [ -0.25    0   0.25  ]
    [ -0.125   0   0.125 ]
  ```
  
By experimenting with different kernels, you can achieve various effects such as blurring, sharpening, and edge detection.


## Content-Aware Image Resizing

## Seam Carving

Seam carving is a technique for content-aware image resizing that removes "seams" (low-energy paths) from the image. The primary goal is to retain the most important features while resizing the image in a way that looks natural.

