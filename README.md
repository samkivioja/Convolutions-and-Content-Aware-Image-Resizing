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

**Seam carving** resizes images by intelligently removing or adding low-energy paths, or "seams," to minimize visual distortion. Here, convolution is used to identify these seams by calculating an **energy function** that measures the importance of each pixel based on edge strength.
When resizing in both dimensions 

### Seam Carving Workflow
These steps are repeated until enough seams are removed to reach the target size.
1. Define energy for the image
2. Find the lowest energy seam through the image
3. Remove the seam from the image

### Energy Function with Convolution and Sobel Filters

The **energy function** calculates a measure of pixel importance, with higher values indicating areas with significant edges or texture. This project uses the **Sobel filters** to detect edges in the horizontal and vertical directions. The steps for calculating the energy function using convolutions are as follows:

1. **Applying Sobel Filters**:
   - The Sobel filters are two 3x3 matrices designed to detect brightness changes along the x (horizontal) and y (vertical) directions.
   - By convolving the image with these filters, we generate two gradient maps representing the horizontal and vertical edges.

2. **Combining Edge Information**:
   - After applying the Sobel filters, the two gradient maps are combined using the Pythagorean theorem to create a comprehensive edge map, which highlights all major edges in the image.

3. **Brightness Adjustment**:
   - Because the Sobel filter detects changes in brightness, the image is first converted to grayscale. This allows the Sobel filters to detect brightness gradients effectively across colored images.

4. **Final adjustment**:
   - Since the human eye doesn't perceive all colors at the same intensity, we can set weights for each color channel based on their perceived contribution to brightness.


### LeastEnergyMap
After defining the energy of the image, we need a way to find the lowest energy seam and then remove it from the image. The `LeastEnergyMap` function helps determine the optimal seams based on the image's energy function.

The `LeastEnergyMap` function calculates a cumulative map, where each pixel’s value represents the minimum energy required to reach that pixel from the top row. By evaluating the sum of the current pixel's energy and the lowest energy from the three pixels directly below it. The cumulative map enables the seam carving algorithm to identify the path of least energy from the top of the image to the bottom, which corresponds to the optimal seam for removal.

### Step-by-Step Breakdown of LeastEnergyMap

1. **Initialize the Last Row**:
   - The function starts by copying the bottom row of the energy matrix `E` to the last row of `least_E`. Each value here represents the energy at that pixel, serving as the starting point for calculating seams.

2. **Iterate from Bottom to Top**:
   - For each pixel (starting from the second-to-last row and moving upward), the function calculates the minimum cumulative energy path by considering the pixel’s energy and the lowest cumulative energy among the three pixels directly below it. This process generates a map that reflects the minimum energy required to reach each pixel from the bottom row.

### Finding and Removing Seams

Once the cumulative energy map is computed, the lowest-energy seam is found by tracing the minimum energy values from the top row downwards according to the directions provided in `LeastEnergyMap`. The seam is then removed from the image, reducing the image's width (or height, depending on the seam direction) without altering significant visual features.

This same operation can be done in the horizontal direction to reduce image height.


