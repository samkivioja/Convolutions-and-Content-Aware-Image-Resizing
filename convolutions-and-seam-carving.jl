### A Pluto.jl notebook ###
# v0.19.42

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 16ed7e4e-f70e-11ee-29ca-9d31a0704ed2
begin
	using Images, FileIO
	using PlutoUI
	using Plots
	using ImageFiltering
	using Colors
	using ColorVectorSpace
	using OffsetArrays
	using Statistics
end

# ╔═╡ b0cb3a8b-b8d5-4414-8c64-de5769384fe5
md"## Convolutions with images"

# ╔═╡ 67a5c9fd-f688-471b-9aca-afd5629e9350
list1 = [1,2,3]

# ╔═╡ 7dc830d6-72f6-4c39-9206-20d7f7f64172
list2 = [4,5,6]

# ╔═╡ 8cce9062-dc2d-4999-ac9f-725e43437f2d
array = [0.1,0.1,0.1,0.1,1,1,1,1,1,0.1,0.1,0.1,0.1,]

# ╔═╡ 96fc3794-d94c-4820-9aff-74bc060754d6
k = [1/3, 1/3, 1/3]

# ╔═╡ 3125c143-f6fd-4aa0-a194-ed7e5ec8eb9b
k2 = [0.25, 0.5, 0.25]

# ╔═╡ b5ed6c4d-f7c7-40d9-9ab1-517a384fac44
begin
	p = bar(array, 
		size=(600, 130), 
		legend=false, 
		framestyle=:none, 
		grid=false, 
		showaxis=false, 
		showticks=false, 
		bg_color="black", 
		linecolor=:lightgray,
		bar_width=1)

		for (i, value) in enumerate(array)
		    annotate!(i, value + maximum(array) * 0.02, text(string(value), :white, 	10, :center))
		end
	p
end

# ╔═╡ 761d8a4f-f508-4d15-bc04-65f1a10b0196
kernel = [
	1/9 1/9 1/9
	1/9 1/9 1/9
	1/9 1/9 1/9
]

# ╔═╡ e4253e05-4512-4282-9337-6069d35ddebb
gauss = Kernel.gaussian((2,2))

# ╔═╡ 63d2c6cf-c39c-4076-9641-8e548d4d37d0
sobel = Kernel.sobel()[1]

# ╔═╡ 4d10ee5d-2355-4a92-8838-fc85737b28e4
kernel2 = [
	-0.5  -1  -0.5
	-1   7   -1
	-0.5  -1  -0.5
]

# ╔═╡ ad78688a-20b1-46bd-94cc-5dd5ab1c4a51
kernel3 = [
		-1.0 -1.0 -1.0
		-1.0 8.0 -1.0
		-1.0 -1.0 -1.0
	]

# ╔═╡ f69b9f69-37ac-4c79-9083-c37e2c34e1d8


# ╔═╡ 01d73ebe-277d-4fba-b680-0f87b8cc5280
md"## Image Resizing With Seams"

# ╔═╡ 05d87004-209a-4198-b62b-f3285e5d1166
begin
	#path = "C:/Users/santt/Pictures/Saved Pictures/ball.png"
	small_ball = load("ball.png")
	scale = 5.0
	new = trunc.(Int, size(small_ball) .* scale)
	ball = imresize(small_ball, (new))
end

# ╔═╡ a61b28d1-3cc0-439d-bd41-e791dc0ee21d
Sy, Sx = Kernel.sobel()

# ╔═╡ d7abf0c7-4ca8-4530-adbc-189196fdba92
Sy[1,1]

# ╔═╡ 6215b5c6-82bb-48e4-ae42-d02d4b6f3132
md""" Second derivative produces zero crossings at edges """

# ╔═╡ a3ce16b4-19a6-4cc9-bede-5b2fcc59e738


# ╔═╡ baa9b63d-7109-4c1d-9251-2689daab0b8f
md"## Function definitions"

# ╔═╡ 7a21d992-dcac-42e0-867e-2348e54b7018
function scale_image(image, percentage_scale)
	new_size = trunc.(Int, size(image) .* percentage_scale)
	new_image = imresize(image, (new_size))
end

# ╔═╡ 41a3399d-f606-47da-92ce-1da92b0f2692
begin
	url = "https://upload.wikimedia.org/wikipedia/en/0/07/Monarch_Butterfly_Flower.jpg"
	download(url, "butterfly.jpg")
	large_image = load("butterfly.jpg")
	image = scale_image(large_image, 0.6)
end

# ╔═╡ 42ccd340-51f2-405a-8d79-91a3faa569b4
typeof(image)

# ╔═╡ 69ae0195-5726-405e-9cf8-fbdd30c0d3eb
image

# ╔═╡ 28dafdf8-4ed1-48cf-9fe2-6b669ed16aba
begin
	waveurl = "https://upload.wikimedia.org/wikipedia/commons/a/a5/Tsunami_by_hokusai_19th_century.jpg"
	download(waveurl, "tsunami.jpg")
	large_wave = load("tsunami.jpg")
	wave = scale_image(large_wave, 0.4)
end

# ╔═╡ 9d4aa7a5-d042-459e-a9c2-50ac933fa3bc
begin
	ImageToCarve_Y = wave
	@bind width Slider(size(ImageToCarve_Y)[2]:-1:1, show_value=true)
end

# ╔═╡ 0e12ebbf-f7a4-49d8-8d3a-8713e1703a44
begin
	ImageToCarve_X = wave
	@bind height Slider(size(ImageToCarve_X)[1]:-1:1, show_value=true)
end

# ╔═╡ 8170e45d-9436-41c6-98f1-3c8fbbf42e5f
ImageToCarve = wave

# ╔═╡ e333cc9c-cbf2-4a57-b09f-c2333c97eabe
size(ImageToCarve)

# ╔═╡ 3b7789af-ccfd-4616-af05-be9e35f3a2ec
imageToResize = wave

# ╔═╡ b483ca6d-0125-419a-839d-09972c293949
size(imageToResize)

# ╔═╡ 886d4189-651a-47b1-ad89-6b7e2a684978
begin
	persistenceofmemory ="https://i.gyazo.com/48241fbf4e652c1eeaf73c599deb5025.jpg"
	download(persistenceofmemory, "The_Persistence_of_Memory.jpg")
	memory = load("The_Persistence_of_Memory.jpg")
	image2 = scale_image(memory, 0.6)
end

# ╔═╡ 6f51fcf5-05c3-49b1-9614-3994fe8a0e98
begin
	img = image2
	img_width = (size(img)[2])
	@bind position Slider(1:img_width, show_value=true)
end

# ╔═╡ d4e755d4-c976-4158-80af-08fdae6bf530
begin
	kuva = image2
	img_height = (size(kuva)[1])
	@bind pos Slider(1:img_height, show_value=true)
end

# ╔═╡ 4eaeba26-316b-4edd-a580-c3b218d3826b
begin
	load("hiroshige.jpg")
	big_hiroshige = load("hiroshige.jpg")
	image3 = scale_image(big_hiroshige, 0.6)
end

# ╔═╡ 49b41bfe-850f-4ca6-9190-f3cb6432a506
size(image3)

# ╔═╡ ff6137eb-43b1-43c2-aa93-b6ee4d622445
begin
	fujiurl = "https://i.gyazo.com/7af30fc9e22dcbf4ccc47430e440acca.jpg"
	download(fujiurl, "fuji.jpg")
	big_fuji = load("fuji.jpg")
	image4 = scale_image(big_fuji, 0.8)
end

# ╔═╡ 2593f350-550b-41a1-885f-a3c2632c1b43
size(image4)

# ╔═╡ 5ee5d537-a9a9-4f00-86fe-8ffd52347d24
begin
	utagawaurl = "https://i.gyazo.com/a1468256249756b054506e60d6331c26.jpg"
	download(utagawaurl, "utagawa.jpg")
	utagawa = load("utagawa.jpg")
	image5 = scale_image(utagawa, 0.7)
end

# ╔═╡ 20cd3f94-796e-4488-af50-d8a6a45119d3
size(image5)

# ╔═╡ e6ccde94-7e14-482a-b97f-4fb764674eae
begin 
	giraffeurl = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Giraffe_Mikumi_National_Park.jpg/1200px-Giraffe_Mikumi_National_Park.jpg"
	download(giraffeurl, "giraffe.jpg")
	big_giraffe = load("giraffe.jpg")
	giraffe = scale_image(big_giraffe, 0.3)
end

# ╔═╡ 34f7b8ed-813f-4afd-aa61-88471db1714e
size(giraffe)

# ╔═╡ 879ed4d3-a846-4ea9-b3c7-f17f9518fe29
begin
	bench_url = "https://pages.cs.wisc.edu/~moayad/cs766/midterm_images/bench3.png"
	download(bench_url, "bench.png")
	og_bench = load("bench.png")
	bench = scale_image(og_bench, 0.8)
end

# ╔═╡ 140b40e3-745d-4379-978d-fd7854a97c2d
size(bench)

# ╔═╡ e3e86596-6604-46f9-a6df-82ef7ee21ebb
begin
	birdurl = "https://static.scientificamerican.com/sciam/cache/file/7A715AD8-449D-4B5A-ABA2C5D92D9B5A21_source.png?w=1200"
	download(birdurl, "bird.png")
	bigbird = load("bird.png")
	bird = scale_image(bigbird, 0.4)
end

# ╔═╡ 241c6fc4-d556-446a-ac0a-871b1bc1709c
size(bird)

# ╔═╡ f175daa0-ea50-4e99-821c-f916756d8222
function show_kernel(kernel)
	to_rgb(x) = RGB(max(x, 0), 0, max(-x, 0))
	to_rgb.(kernel) / maximum(abs.(kernel))
end

# ╔═╡ ac815971-3ff2-4afc-b4b0-7382c9b5dd74
show_kernel(gauss)

# ╔═╡ 589c2ca0-e9d8-40d9-8e65-2170cbd75aef
show_kernel(sobel)

# ╔═╡ b50d7a3a-b980-4a0a-9515-abab70e93370
show_kernel(kernel2)

# ╔═╡ 83cb7719-0a9a-4957-93e2-fa59ab1b00d5
show_kernel(kernel3)

# ╔═╡ b277e483-f577-40d8-a57b-93513621a0e9
[show_kernel(Sx) show_kernel(Sy)]

# ╔═╡ 7a22b815-f79e-4648-89be-7d0a1be3ee4d
function show_image(matrix)
	to_rgb(x) = RGB(max(x, 0) , max(x, 0), max(x, 0))
	to_rgb.(matrix) / maximum(abs.(matrix))
end

# ╔═╡ 4bacc97c-e169-406a-ac0e-b17495cbd33e
function hbox(x, y, gap=16; sy=size(y), sx=size(x))
	w,h = (max(sx[1], sy[1]),
		   gap + sx[2] + sy[2])
	
	slate = fill(RGB(1,1,1), w,h)
	slate[1:size(x,1), 1:size(x,2)] .= RGB.(x)
	slate[1:size(y,1), size(x,2) + gap .+ (1:size(y,2))] .= RGB.(y)
	slate
end

# ╔═╡ a92b71eb-38f4-4e12-a86f-634bac10d03f
vbox(x,y, gap=16) = hbox(x', y')'

# ╔═╡ fd498b6c-6dee-416a-9bfa-fb1132526dfe
function indexOrZero(v::AbstractVector, i)
	if 1 <= i <= length(v)
		return v[i]
	else
		return 0
	end
end

# ╔═╡ cc76745a-a351-489e-a2ab-b98e1e96fd09
function extend(v::AbstractVector, i)
	if 1 <= i <= length(v)
		return v[i]
	else
		if  abs(i - 1) < abs(i - length(v))
			return v[1]
		else
			return v[end]
		end
	end
end

# ╔═╡ 0960477a-0442-4e4d-b265-9f5e9babda86
function extend(M::Matrix, i, j)
	rows, cols = size(M)

	i = i < 1 ? 1 : (i > rows ? rows : i)
	j = j < 1 ? 1 : (j > cols ? cols : j)

	return M[i, j]
end

# ╔═╡ 5a44377c-6f5c-47c8-9ac8-bf5412df97b1
function clamp_to_bounds(value)
    if value isa Number
        max_value = typemax(typeof(value))
        return min(max_value, max(zero(typeof(value)), value))
    elseif value isa Colorant
        return mapc(x -> min(typemax(typeof(x)), max(zero(typeof(x)), x)), value)
    else
        throw(ArgumentError("Unsupported type $(typeof(value))"))
    end
end



# ╔═╡ 0c5ae1af-ba26-4341-b7d9-59c3c0fdd7dc
function clamp_to_zero_one(value)
    if value isa Number
        return min(1.0, max(0.0, value))
    elseif value isa Colorant
        return mapc(x -> min(1.0, max(0.0, x)), value)
    else
        throw(ArgumentError("Unsupported type $(typeof(value))"))
    end
end

# ╔═╡ d91deb0f-ea8a-4d88-b94e-bcb8baa9f5b3
function mirror(m)
	
	if isa(m, OffsetArray)

		rows, cols = size(m) .÷ 2
    	mirrored = zero(m)
		
	    for i in -rows:rows
			for j in -cols:cols
				if i != 0 || j != 0
					mirrored[i, -j] = m[i, j]
				else
					mirrored[i,j] = m[i, j]
				end
			end
		end

		return mirrored
		
	else
		return m[:, end:-1:1]
	end

end

# ╔═╡ 03a4da3d-8456-4cf3-8af8-172288b6a326
function Convolve(v::AbstractVector, k::AbstractVector)

	k = reverse(k)
	window = similar(k)
	size = (length(v) + length(k) - 1) # The size of a 1D convolution is (N + M - 1)
	convolved = similar(v, size) # where N and M are the lengths of the 2 vectors 
	
	for i in 1:length(convolved)
		for j in 1:length(k)
			idx = i - (length(k) ÷ 2) + j - (1 + (length(k) ÷ 2))
			window[j] = indexOrZero(v, idx) * k[j]
		end
		convolved[i] = sum(window)
	end
	return convolved
end

# ╔═╡ 4b6e3ac6-a7c3-4975-9768-7a55c96b55cd
Convolve(list1, list2)

# ╔═╡ 7fe25220-d7c2-4ef4-a1b2-8056a784e14c
begin
	data = Convolve(array, k2)

	function format_value(value, decimals)
	    rounded_value = round(value, digits=decimals)
	    return string(rounded_value)
	end
	
	plot = bar(data, 
		size=(600, 130), 
		legend=false, 
		framestyle=:none, 
		grid=false, 
		showaxis=false, 
		showticks=false, 
		bg_color="black", 
		linecolor=:lightgray,
		bar_width=1)

		for (i, value) in enumerate(data)
		    annotate!(i, value + maximum(data) * 0.02, text(format_value(value,3), :white, 	10, :center))
		end
	plot
end

# ╔═╡ e1a6ae2e-6df3-4375-89f2-512fc60a9199
function convolve(v::AbstractVector, k)
	convolved = similar(v)
	k = reverse(k)
	window = similar(k)
	for i in 1:length(v)
		for j in 1:length(k)
			idx = i - (length(k) ÷ 2) + j - 1
			window[j] = extend(v, idx) * k[j]
		end
		convolved[i] = sum(window)
	end
	return convolved
end

# ╔═╡ 132238d6-fb35-4692-9fff-0f95024f44c8
function convolve(M::AbstractMatrix, K::AbstractMatrix)
	M′ = zero(M)
	rows, cols = size(M)
	
	lr, lc = size(K) .÷ 2 #Find center of K

	mirrorK = mirror(K)
	
    if isa(K, OffsetArray)
			
		for i in 1:rows
        	for j in 1:cols
            	acc = M′[i, j]
            	for r_offset in -lr:lr
                	for c_offset in -lc:lc
                        acc += extend(M, i + r_offset, j + c_offset) * 
						mirrorK[r_offset, c_offset]
                	end
            	end
           		M′[i, j] = abs(acc)
        	end
    	end

		
	else
		
		for i in 1:rows
			for j in 1:cols
				acc = M′[i, j] #Initialize accumulator
				for r_offset in -lr:lr
					for c_offset in -lc:lc
						#K centered at (lr+1 lc+1)
						acc += extend(M, i + r_offset, j + c_offset) * mirrorK[lr+1 + r_offset, lc+1 + c_offset]
					end
				end
				M′[i,j] = clamp_to_zero_one(acc)
			end
		end
	end
		
	return M′
end

# ╔═╡ 69c94c03-5f6c-4fc8-9ae9-64813a1d5a31
convolvedImage = convolve(image, gauss)

# ╔═╡ 93d20de9-cd4d-4a47-92b5-f78bd2e80781
[image convolvedImage]

# ╔═╡ a6586b85-30df-4f9e-8d2a-07dd6f9a2679
convolve(image, kernel3)

# ╔═╡ 1860775b-94e0-4479-b3e8-6bfed9396cf3
[convolve(ball,Sx) convolve(ball,Sy)]

# ╔═╡ b64a9c4c-5619-4e74-8d35-913850e91184
function brightness(img)
	return img = 0.3 * img.r + 0.59 * img.g + 0.11 * img.b
end

# ╔═╡ 2c63b06f-1a90-445c-ba3c-485ef5110dc2
[show_image(convolve(brightness.(ball),Sx)) show_image(convolve(brightness.(ball),Sy))]

# ╔═╡ 8fd5a173-3efe-4554-955c-f1281323dd9f
[show_image(convolve(brightness.(image), Sx)) show_image(convolve(brightness.(image), Sy))]

# ╔═╡ b9eda326-f335-4566-aa6b-a4d25e5f8d2a
begin
	b = brightness.(image2)
	x = convolve(b, Sx)
	y = convolve(b, Sy)
	[show_image(x) show_image(y)]
end

# ╔═╡ 9e4c1c18-cab2-441f-8550-35f5e9b4df30
function edges(image, energy, seam)
	Sy, Sx = mirror(Kernel.sobel()[1]), mirror(Kernel.sobel()[2])
	m, n = size(image)
	lr, lc = size(Sy) .÷ 2
	b = brightness.(image)

	for i in 1:m
		for j in -1:1
			Mj = seam[i]+j
			if Mj < 1
				Mj = 1
			elseif Mj > m
				Mj = m
			end
			if j != 0
				accY = 0 * b[1, 1]
				accX = 0 * b[1, 1]
				for r_offset in -lr:lr
					for c_offset in -lc:lc
						accY += extend(b, i + r_offset, Mj + c_offset) *  Sy[r_offset, c_offset]
						accX += extend(b, i + r_offset, Mj + c_offset) *  Sx[r_offset, c_offset]
					end
				end
				energy[i, Mj] = sqrt(accX^2 + accY^2)
			end
		end
	end
	return Gray.(energy) ./ maximum(energy)
end

# ╔═╡ 7b31abbd-8f3a-4b12-b9fd-949be9fc9b3c
function edges1(image, edges, seam)
	Sy, Sx = mirror(Kernel.sobel()[1]), mirror(Kernel.sobel()[2])
	lr, lc = size(Sy) .÷ 2
	m, n = size(image)
	for i in 1:m
		if seam[i] == 1
			accY = 0.0
			accX = 0.0
			for r_offset in -lr:lr
				for c_offset in -lc:lc
					b = brightness(extend(image, i + r_offset, seam[i] + c_offset))
					accY += b *  Sy[r_offset, c_offset]
					accX += b *  Sx[r_offset, c_offset]
				end
			end
			edge = abs(sqrt(accY^2 + accX^2))
			edges[i, 1] = Gray(edge)
			
		elseif seam[i] == n+1
			accY = 0.0
			accX = 0.0
			for r_offset in -lr:lr
				for c_offset in -lc:lc
					b = brightness(extend(image, i + r_offset, seam[i]-1 + c_offset))
					accY += b *  Sy[r_offset, c_offset]
					accX += b *  Sx[r_offset, c_offset]
				end
			end
			edge = abs(sqrt(accY^2 + accX^2))
			edges[i, n] = Gray(edge)
			
		else
			accY = 0.0
			accX = 0.0
			for r_offset in -lr:lr
				for c_offset in -lc:lc
					b = brightness(extend(image, i + r_offset, seam[i]-1 + c_offset))
					accY += b *  Sy[r_offset, c_offset]
					accX += b *  Sx[r_offset, c_offset]
				end
			end
			edge = abs(sqrt(accY^2 + accX^2))
			edges[i, seam[i]-1] = Gray(edge)

			accY = 0.0
			accX = 0.0
			for r_offset in -lr:lr
				for c_offset in -lc:lc
					b = brightness(extend(image, i + r_offset, seam[i] + r_offset))
					accY += b *  Sy[r_offset, c_offset]
					accX += b *  Sx[r_offset, c_offset]
				end
			end
			edge = abs(sqrt(accY^2 + accX^2))
			edges[i, seam[i]] = Gray(edge)

		end
	end
	return edges #./ maximum(edges)
	#=  
		where image and energy have the seam removed
		and n equals the width of the image:
	
		if seam[i] = 1 then the edges should be calculated at only...
    		...image[1] (or image[seam[i]] since it's the same value)

		if seam[i] = n+1 (the edge of the image without the seam removed)
			then the edges should be calculated at only...
			...image[n] (or image[seam[i]-1) since it's the same value)

		otherwise the edges should be calulated at seam[i]-1 and seam[i] 
	=#
end

# ╔═╡ 78777334-b791-4dab-8624-7e87bd4eeb5c
function edges2(image, edges, seam)
    # Sobel filters
	Sy, Sx = mirror(Kernel.sobel()[1]), mirror(Kernel.sobel()[2])

    rows, cols = size(image)

    # Iterate over each point in the seam
    for i in 1:length(seam)
        row = i
        col = seam[i]

        for r in max(1, row-1):min(rows, row+1)
            for c in max(1, col-1):min(cols, col+1)
                ∇x = 0
                ∇y = 0

                # Compute the gradient in x and y directions
                for kr in -1:1
                    for kc in -1:1
                        b = brightness(extend(image, r + kr, c + kc))
                        ∇x += b * Sx[kr, kc]
                        ∇y += b * Sy[kr, kc]
                    end
                end
				
                # Update the energy function
                edges[r, c] = sqrt(∇x^2 + ∇y^2)
            end
        end
    end
    return edges
end

# ╔═╡ 2022992c-714c-440d-8c30-8f0038ff317e
function edges(img)
	Sy, Sx = Kernel.sobel()
	b = brightness.(img)

	∇y = convolve(b, Sy)
	∇x = convolve(b, Sx)

	edge = sqrt.(∇x.^2 + ∇y.^2)
	Gray.(edge) / maximum(edge)
end

# ╔═╡ 582e0e2e-a796-4c7c-bff9-848c6fedb46f
[ball edges(ball)]

# ╔═╡ b2b8ec59-f073-4faf-a549-4a0cca54348e
edges(wave)

# ╔═╡ fe6f830b-c2d7-4317-b647-27a6858cc2f3
edgyness = edges(image2)

# ╔═╡ 3e7887d9-0165-4a73-a97c-5a49274d56f0
edges(image3)

# ╔═╡ b8e2adc5-4f63-4ec1-8395-874297b7c27f
edges(image4)

# ╔═╡ 22ad9ba6-7d35-420a-a7d1-52ea948134e6
edges(image5)

# ╔═╡ 57cf5b1e-5d33-448d-a672-b06e7318a51a
edges(bird)

# ╔═╡ 2c7dc971-641c-423e-8f57-e03891959be3
function edges2(img)
	Sy, Sx = Kernel.sobel()
	b = Gray.(img)

	∇y = convolve(b, Sy)
	∇x = convolve(b, Sx)

	edge = sqrt.(∇x.^2 + ∇y.^2)
	edge ./ maximum(edge)
end

# ╔═╡ 4621e53c-07ba-4e55-ab68-205353156181
[edges2(ball) edges2(edges2(ball))]

# ╔═╡ 76b12046-e63d-4c85-9bf0-9fc95bba7391
[edges2(edges2(image)) edges(image)]

# ╔═╡ d828b425-051e-4e75-8bda-e27ba8bc4ed6
[edges2(image) edges(image)]

# ╔═╡ b6426840-25cf-4f08-9c1d-604ffbd540c8
edge = edges2(image2)

# ╔═╡ 7783364a-3d48-485b-92c4-532a3306cb9c
function DrawSeam_X(img, seam)
	seam_img = copy(img)
	for j in 1:size(img)[2]
		seam_img[seam[j], j] = RGB(1, 0, 1) #1,0,1
	end
	return seam_img
end

# ╔═╡ 0396b46a-7070-498b-8c59-605f4fe30a9d
function DrawSeam_Y(img, seam)
	seam_img = copy(img)
	for i in 1:size(img)[1]
		seam_img[i, seam[i]] = RGB(1, 0, 1) #1,0,1
									#0.99607843137,0,0.88235294117
	end
	return seam_img
end

# ╔═╡ 76360fb4-5678-4a53-8f14-03ad16c26a83
#           E[x+1, y-1]
#         ↗
# E[x, y] → E[x+1, y]
#         ↘
#           E[x+1, y+1]

function LeastEnergyMap_X(E)
    least_E = zeros(size(E))
    directions = zeros(Int, size(E))
    n, m = size(E)

    least_E[:, end] .= E[:, end] # Minimum energy on the last column is the energy itself

    for j in m-1:-1:1 # From second-to-last column to the first
        for i in 1:n # Top to bottom
            up, down = max(1, i-1), min(i+1, n) # Max/Min for staying in bounds
            e, dir = findmin(least_E[up:down, j+1]) # Minimum energy and index
            least_E[i, j] += e + E[i, j]
            directions[i, j] = dir - 2 # direction will be -1, 0, or 1

            if i == 1 # Edge case of -1 at the top.
                directions[i, j] += 1
            end
        end
    end

    return least_E, directions
end

# ╔═╡ 952fd123-be34-42c8-ac46-ff2778f69349
leastE = show_image(LeastEnergyMap_X(edgyness)[1])

# ╔═╡ dd3d5889-6b31-48da-8b6f-e4e3c1746c62
[image2 edgyness leastE]

# ╔═╡ fff7b18e-a0d6-4bfb-bd52-b7bd3f3fd545
emap = LeastEnergyMap_X(edgyness)[1]

# ╔═╡ 89a789ad-bdf5-44cf-a9ac-2e0b73cb590d
typeof(emap)

# ╔═╡ b1e2539c-3789-4e70-ab2e-a52d865daf85
top = emap[1,:]

# ╔═╡ 3e188be8-08c5-4b60-abd6-cc9814dddf8b
directions = LeastEnergyMap_X(edgyness)[2]

# ╔═╡ e093acf2-c092-4f39-83bb-ea5bf050c82c
show_image(LeastEnergyMap_X(edges(bird))[1])

# ╔═╡ fb5de843-f7b5-40ac-a822-0079033bd9c9
#              E[x, y]
#          ↙      ↓      ↘ 
# E[x-1, y+1]  E[x, y+1]  E[x+1, y+1]

function LeastEnergyMap_Y(E)
	least_E = zeros(size(E))
	directions = zeros(Int, size(E))
	n, m = size(E)
	
	least_E[end, :] .= E[end, :] # Minimum energy on the last row is the energy itself
	
	for i in n-1:-1:1	# From second-last row up
		for j in 1:m	# Left to right
			left, right = max(1, j-1), min(j+1, m) # Max/Min for staying in bounds
			e, dir = findmin(least_E[i+1, left:right]) # Minimum energy and index
									# i+1(going down). index will be 1, 2 or 3
			least_E[i, j] += e + E[i, j]
			directions[i, j] = dir - 2	# direction will be -1, 0 or 1 
			
			if j == 1 # Edge case of -1 on the left. Also all 0's on the left
				directions[i, j] += 1
			end
		end
	end

	return least_E, directions
	
end

# ╔═╡ 67db4cf2-be2b-437c-bcb7-0de160d551fc
leastEnergy = show_image(LeastEnergyMap_Y(edges(image2))[1])

# ╔═╡ 7caad4de-77de-40b2-ac6f-2c2049809aa9
[image2 edge edgyness leastEnergy]

# ╔═╡ 066049e4-d67a-4765-9e92-1c5a408ccbdd
energypath = LeastEnergyMap_Y(edges(image2))[2]

# ╔═╡ 0570e1fd-6cb9-43cc-bbf3-da91d6c30ee4
[ImageToCarve edges(ImageToCarve) show_image(LeastEnergyMap_X(edges(ImageToCarve))[1]) show_image(LeastEnergyMap_Y(edges(ImageToCarve))[1])]

# ╔═╡ 907dff8c-fa1b-4130-b96b-630bc42acb7f
show_image(LeastEnergyMap_Y(edges(image3))[1])

# ╔═╡ 8b7ad2c5-2fc3-4e16-bb47-6b60bdc40083
show_image(LeastEnergyMap_Y(edges(image5))[1])

# ╔═╡ 7b828088-0906-46fd-b9c3-25516b577808
show_image(LeastEnergyMap_Y(edges(bird))[1])

# ╔═╡ 26b22c6f-8305-4114-8f95-5969a69ffff6
function FindSeamAt_X(directions, position)
    seam = zeros(Int, size(directions)[2])

    seam[1] = position

    for j = 2:length(seam)
        seam[j] = seam[j-1] + directions[seam[j-1], j]
    end

    return seam
end

# ╔═╡ f89a4815-2606-49a3-bded-28b1bfdfcb15
DrawSeam_X(img, FindSeamAt_X(LeastEnergyMap_X(edges(img))[2], pos))

# ╔═╡ 3c502d3f-7131-4d4f-87b6-9f3c2e20f94a
function FindSeamAt_Y(directions, position) # position of where the seam starts
	seam = zeros(Int, size(directions)[1]) 
	
	seam[1] = position
	
	for i = 2:length(seam)
		seam[i] = seam[i-1] + directions[i, seam[i-1]]
	end

	return seam
end

# ╔═╡ 285ee5e9-ef8f-40c7-bde5-94e6eeae7a12
DrawSeam_Y(img, FindSeamAt_Y(LeastEnergyMap_Y(edges(img))[2], position))

# ╔═╡ 88baaa6e-51a9-4c38-b753-09bdd389bb11
function FindSeam_X(energy) # Returns the lowest energy seam
	leastE_map, directions = LeastEnergyMap_X(energy)
	least_energy, position = findmin(leastE_map[:,1]) #lowest value and index 1st col
	return FindSeamAt_X(directions, position)
end

# ╔═╡ 9f2f2da0-a054-4080-bda9-28a092af6f40
lowest_e_seam = FindSeam_X(LeastEnergyMap_X(edges(image2))[1])

# ╔═╡ 751612f3-d160-4c2d-beb6-503acd6ff1cc
DrawSeam_X(image2, lowest_e_seam)

# ╔═╡ ac073bb7-6c08-4d5a-b533-c521b0f7a8d3
function FindSeam_Y(energy) # Returns the lowest energy seam
	leastE_map, directions = LeastEnergyMap_Y(energy)
	least_energy, position = findmin(leastE_map[1,:]) #lowest value and index top row
	return FindSeamAt_Y(directions, position)
end

# ╔═╡ df7e85d0-ad1f-45e6-bbc2-549d7a6dda73
lowest_energy_seam = DrawSeam_Y(image2, FindSeam_Y(LeastEnergyMap_Y(edges(image2))[1]))

# ╔═╡ eeb5a65f-1a4a-4440-8d9d-ac0e2b01eefe
function FindSeam(energy)
	leastE_map_X, dirX = LeastEnergyMap_X(energy)
	leastE_map_Y, dirY = LeastEnergyMap_Y(energy)
	leastE_X, positionX = findmin(leastE_map_X[:,1])
	leastE_Y, positionY = findmin(leastE_map_Y[1,:])

	if leastE_X < leastE_Y
		return "x", FindSeamAt_X(dirX, positionX)
	else
		return "y", FindSeamAt_Y(dirY, positionY)
	end
end

# ╔═╡ d5c667c3-6c48-414d-9ad5-e3962550a8f0
function RemoveSeam_X(image::Matrix{T}, seam) where T
    resolution = (size(image)[1] - 1, size(image)[2])
    new_image = Matrix{T}(undef, resolution)

    for j = 1:length(seam)
        if seam[j] > 1 && seam[j] < size(image)[1]
            new_image[:, j] .= vcat(image[1:seam[j]-1, j], 
                                    image[seam[j]+1:end, j]) 
            # vcat() chains 2 arrays into a vertical array

        elseif seam[j] == 1
            new_image[:, j] = image[2:end, j]
        elseif seam[j] == size(image)[1]
            new_image[:, j] = image[1:end-1, j]
        end
    end
    return new_image
end

# ╔═╡ 4735c79e-00cc-45f1-b367-d2aba418985c
function RemoveSeam_Y(image::Matrix{T}, seam) where T
	resolution = (size(image)[1], size(image)[2]-1)
	new_image = Matrix{T}(undef, resolution)

	for i = 1:length(seam)
		if seam[i] > 1 && seam[i] < size(image)[2]
			new_image[i, :] .= vcat(image[i, 1:seam[i]-1], 
									image[i, seam[i]+1:end]) 
			# vcat() chains 2 arrays into a vertical array

		elseif seam[i] == 1
			new_image[i, :] = image[i, 2:end]
		elseif seam[i] == size(image)[2]
			new_image[i, :] = image[i, 1:end-1]
		end
	end
	return new_image
end

# ╔═╡ 54a174ba-4210-420f-b5e9-2ad0f4f254e0
function SeamCarving_X(img, height)
	img_height = size(img)[1]
	if height < 0 || height > img_height
		return "height not in bounds of the image"
	end

	for i = (1:img_height-height)
		energy = edges(img)
		seam = FindSeam_X(energy)
		img = RemoveSeam_X(img, seam)
	end

	return img
end

# ╔═╡ 98df5eda-0369-4250-bc3d-870933402aac
carved_image_X = SeamCarving_X(ImageToCarve_X, height)

# ╔═╡ af1211a4-8cfe-4094-b6ee-61426651361a
hbox(ImageToCarve_X, carved_image_X, sy=size(ImageToCarve_X), sx=size(carved_image_X))

# ╔═╡ 437d0bb0-4c9f-4550-a709-25e29bc5f42c
function SeamCarving_Y(img, width)
	img_width = size(img)[2]
	if width < 0 || width > img_width
		return "width not in bounds of the image"
	end
	
	for i = (1:img_width-width)
		energy = edges(img)
		seam = FindSeam_Y(energy)
		img = RemoveSeam_Y(img, seam)
	end
	
	return img
end

# ╔═╡ 04a7dd6f-0ee1-43ff-8c07-363736d9749a
carved_image_Y = SeamCarving_Y(ImageToCarve_Y, width)

# ╔═╡ 84594768-a00f-45d3-9734-a6a496435f6b
[ImageToCarve_Y carved_image_Y]

# ╔═╡ 59ea916b-974d-49ec-876c-837193664058
function SeamCarving_Y1(img, width)
	img_width = size(img)[2]
	if width < 0 || width > img_width
		return "width not in bounds of the image"
	end
	energy = edges(img)
	
	for i = (1:img_width-width)
		#if width < img_width
			seam = FindSeam_Y(energy)
			img = RemoveSeam_Y(img, seam)
			energy = RemoveSeam_Y(energy, seam)
		#else
			energy = edges(img, energy, seam)
		#end
	end
	
	return img
end

# ╔═╡ 91a52719-187a-4967-9c2d-78a965bc4da1
function SeamCarving(img, height, width)
	img_height, img_width = size(img)
	if height < 0 || height > img_height
		return "height not in bounds of the image"
	elseif width < 0 || width > img_width
		return "width not in bounds of the image"
	end

	n = img_height
	m = img_width
	while true
		if n == height
			for i = 1:m-width
				energy = edges(img)
				seam = FindSeam_Y(energy)
				img = RemoveSeam_Y(img, seam)
			end
			break
		elseif m == width
			for j = 1:n-height
				energy = edges(img)
				seam = FindSeam_X(energy)
				img = RemoveSeam_X(img, seam)
			end
			break
		else
			energy = edges(img)
			XY, seam = FindSeam(energy)
			if XY == "x"
				img = RemoveSeam_X(img, seam)
				n -= 1
			else
				img = RemoveSeam_Y(img, seam)
				m -= 1
			end
		end
	end

	return img
end

# ╔═╡ 4b65334f-57b3-4708-a944-765915e363ef
carved_image = SeamCarving(ImageToCarve, 850, 1300)

# ╔═╡ a8fc675e-9a2a-4efa-84d3-a5ee8dd74ce4
hbox(ImageToCarve, carved_image, sy=size(ImageToCarve), sx=size(carved_image))

# ╔═╡ 6ae230e8-af2c-47de-b884-64119b106e1a
size(carved_image)

# ╔═╡ 9c461725-fc55-4d28-835a-fbf3831cf06d
function SeamOrder_X(image, m)
	order = []#[zeros(Int, n)]

	for i in 1:m
		energy = edges(image)
		leastE_map, directions = LeastEnergyMap_X(energy)
		_, position = findmin(leastE_map[:,1])
		seam = FindSeamAt_X(directions, position)
		image = RemoveSeam_X(image, seam)
		push!(order, seam)
	end

	return order
end

# ╔═╡ 8154e276-3258-4ec4-aca1-1b73f3c3c4e6
function SeamOrder_Y(image, n)
	order = []#[zeros(Int, n)]

	for i in 1:n
		energy = edges(image)
		leastE_map, directions = LeastEnergyMap_Y(energy)
		_, position = findmin(leastE_map[1,:])
		seam = FindSeamAt_Y(directions, position)
		image = RemoveSeam_Y(image, seam)
		push!(order, seam)
	end

	return order
end

# ╔═╡ a7ecf354-59aa-40fb-bfae-beb200664a91
function SeamOrder(image, n, m)
	orderY = []
	orderX = []
	seamEnergyY = []
	seamEnergyX = []

	for i in 1:n
		energy = edges(image)
		leastE_map, directions = LeastEnergyMap_Y(energy)
		leastE, position = findmin(leastE_map[1,:])
		seam = FindSeamAt_Y(directions, position)
		image = RemoveSeam_Y(image, seam)
		push!(seamEnergyY, leastE)
		push!(orderY, seam)
	end

	for i in 1:m
		energy = edges(image)
		leastE_map, directions = LeastEnergyMap_X(energy)
		leastE, position = findmin(leastE_map[:,1])
		seam = FindSeamAt_X(directions, position)
		image = RemoveSeam_X(image, seam)
		push!(seamEnergyX, leastE)
		push!(orderX, seam)
	end

	averageE_Y = sum(seamEnergyY) / n
	averageE_X = sum(seamEnergyX) / m

	return orderY, orderX, averageE_Y, averageE_X
end

# ╔═╡ 07ae1e36-46f4-4372-8f23-28c8b31a2d1a
function adjust_indices_X(seams, image_width)
    adjusted_seams = []
    for (i, seam) in enumerate(seams)
        adjusted_seam = []
        for x in 1:image_width
            y = seam[x]
            # Adjust y based on the number of seams already inserted before this one
            adjusted_y = y + sum([1 for s in adjusted_seams if s[x] <= y])
            push!(adjusted_seam, adjusted_y)
        end
        push!(adjusted_seams, adjusted_seam)
    end
    return adjusted_seams
end

# ╔═╡ 6e6740b0-13c2-4925-ba86-654c3093f977
function adjust_indices_Y(seams, image_height)
    adjusted_seams = []
    for (i, seam) in enumerate(seams)
        adjusted_seam = []
        for y in 1:image_height
            x = seam[y]
            # Adjust x based on the number of seams already inserted before this one
            adjusted_x = x + sum([1 for s in adjusted_seams if s[y] <= x])
            push!(adjusted_seam, adjusted_x)
        end
        push!(adjusted_seams, adjusted_seam)
    end
    return adjusted_seams
end

# ╔═╡ e920d8bb-300a-4445-ba78-d9d57842627d
function adjust_indices(seamOrder, img_height, img_width)
    adjusted_seams = []
    x_count = 0
    y_count = 0
    
    for (direction, seam) in seamOrder
        if direction == "y"
            adjusted_seam = []
            for y in 1:img_height
                x = seam[y]
                adjusted_x = x + sum([1 for (d, s) in adjusted_seams if d == "y" && s[y] <= x])
                push!(adjusted_seam, adjusted_x)
            end
            push!(adjusted_seams, ("y", adjusted_seam))
            y_count += 1
        else
            adjusted_seam = []
            for x in 1:img_width
                y = seam[x]
                adjusted_y = y + sum([1 for (d, s) in adjusted_seams if d == "x" && s[x] <= y])
                push!(adjusted_seam, adjusted_y)
            end
            push!(adjusted_seams, ("x", adjusted_seam))
            x_count += 1
        end
    end

    return adjusted_seams
end

# ╔═╡ cf1766bf-49ef-422c-99fa-9123efe00485
function AddSeam_X(image::Matrix{T}, seam) where T
    resolution = (size(image)[1] + 1, size(image)[2])
    new_image = Matrix{T}(undef, resolution)

    for j = 1:length(seam)
        if seam[j] > 1 && seam[j] < size(image)[1]
            new_image[:, j] .= vcat(image[1:seam[j], j], 
                                    mean([image[seam[j], j], image[seam[j]+1, j]]), 
                                    image[seam[j]+1:end, j]) 
        elseif seam[j] == 1
            new_image[:, j] .= vcat(image[1, j], 
                                    mean([image[1, j], image[2, j]]), 
                                    image[2:end, j])
        elseif seam[j] == size(image)[1]
            new_image[:, j] .= vcat(image[1:end, j], 
                                    mean([image[end-1, j], image[end, j]]))
        end
    end
    return new_image
end

# ╔═╡ 75d03671-c3f0-4049-bb80-d3e2537def12
function AddSeam_Y(image::Matrix{T}, seam) where T
    resolution = (size(image)[1], size(image)[2]+1)
    new_image = Matrix{T}(undef, resolution)

    for i = 1:length(seam)
        if seam[i] > 1 && seam[i] < size(image)[2]
            new_image[i, :] .= vcat(image[i, 1:seam[i]], 
                                    mean([image[i, seam[i]], image[i, seam[i]+1]]), 
                                    image[i, seam[i]+1:end]) 
        elseif seam[i] == 1
            new_image[i, :] .= vcat(image[i, 1], 
                                    mean([image[i, 1], image[i, 2]]), 
                                    image[i, 2:end])
        elseif seam[i] == size(image)[2]
            new_image[i, :] .= vcat(image[i, 1:end], 
                                    mean([image[i, end-1], image[i, end]]))
        end
    end
    return new_image
end

# ╔═╡ 701229cb-d560-42e9-a1ab-8ab11b7ade07
seam_added = AddSeam_Y(image2, FindSeam_Y(LeastEnergyMap_Y(edges(image2))[1]))

# ╔═╡ 8b58ab34-18e4-4d92-b52e-bad87cae91e4
function SeamAdding_X(img, height)
	img_height, img_width = size(img)
	if height < 0 || height < img_height
		return "provide a width greater than that of the images"
	end

		# To avoid adding the same lowest value seam over and over, 
		# the seams should be added in the order of "removal".
		# Adding the lowest value seam and then the next lowest
		# produces the wanted effect

	n = height - img_height
	seamOrder = SeamOrder_X(img, n)
	seams = adjust_indices_X(seamOrder, img_width)
	
	for i in 1:n
		seam = seams[i]
		img = AddSeam_X(img, seam)
	end
	return img
end

# ╔═╡ cf641a29-14cd-411f-b0e4-86164cfa54ad
hbox(giraffe, SeamAdding_X(giraffe, 525))

# ╔═╡ 77fc6bb2-2878-428c-8c08-f3778da2c4ee
function SeamAdding_Y(img, width)
	img_height, img_width = size(img)
	if width < 0 || width < img_width
		return "provide a width greater than that of the images"
	end

		# To avoid adding the same lowest value seam over and over, 
		# the seams should be added in the order of "removal".
		# Adding the lowest value seam and then the next lowest
		# produces the wanted effect

	n = width - img_width
	seamOrder = SeamOrder_Y(img, n)
	seams = adjust_indices_Y(seamOrder, img_height)
	
	for i in 1:n
		seam = seams[i]
		img = AddSeam_Y(img, seam)
	end
	return img
end

# ╔═╡ dd2725de-1d81-4262-91ea-6c2df5e11495
seamsAdded = SeamAdding_Y(wave, 1750)

# ╔═╡ 0edbf691-6e01-4bce-9ed8-e712eb37ca1d
size(seamsAdded)

# ╔═╡ 78d7f0e8-60a6-427d-93cd-666672298d0c
hbox(wave, seamsAdded)

# ╔═╡ ecb6ed97-8590-4101-8df1-9a598f734892
wider = SeamAdding_Y(image3, 460)

# ╔═╡ 046f2d5c-11ff-450c-a4cf-3eeacb3cd9d6
hbox(image3, wider)

# ╔═╡ 0ccdd4a3-e8db-4d24-8da9-629cea9c7479
fuji = SeamAdding_Y(image4, 500)

# ╔═╡ 4ea5da47-e0e2-4b5d-bb50-d9105e9e63a2
hbox(image4, fuji)

# ╔═╡ 9c131970-d45c-4f51-86cd-6cf6f3f4718a
hbox(image5, SeamAdding_Y(image5, 450))

# ╔═╡ 7238526e-b1c9-4aac-a97b-139c53138803
SeamAdding_Y(bench,500)

# ╔═╡ b698e689-7e30-4846-afbf-e5c0f3873b6c
function SeamAdding(img, target_height, target_width)
	img_height, img_width = size(img)
    if target_height <= img_height || target_width <= img_width
        return "Provide a target size greater than the current size of the image"
    end
	m = target_height - img_height
	n = target_width - img_width
	

	if img_height > img_width
		seamOrderY = SeamOrder_Y(img, n)
		seamsY = adjust_indices_Y(seamOrderY, size(img)[1])
		for i in 1:n
			seam = seamsY[i]
			img = AddSeam_Y(img, seam)
		end
		seamOrderX = SeamOrder_X(img, m)
		seamsX = adjust_indices_X(seamOrderX, size(img)[2])
		for i in 1:m
		seam = seamsX[i]
		img = AddSeam_X(img, seam)
		end
	else
		seamOrderX = SeamOrder_X(img, m)
		seamsX = adjust_indices_X(seamOrderX, size(img)[2])
		for i in 1:m
		seam = seamsX[i]
		img = AddSeam_X(img, seam)
		end
		seamOrderY = SeamOrder_Y(img, n)
		seamsY = adjust_indices_Y(seamOrderY, size(img)[1])
		for i in 1:n
			seam = seamsY[i]
			img = AddSeam_Y(img, seam)
		end
	end

	return img
end

# ╔═╡ 9efde71a-6a45-4c2c-a7ab-236fdc07c549
bigBird = SeamAdding(bird, 450, 540)

# ╔═╡ e034819e-2f97-460f-a8d0-f0901ddfd40e
size(bigBird)

# ╔═╡ f3a45e02-2467-4e1a-b7d8-33b004dc2b97
hbox(bird, bigBird)

# ╔═╡ 9eb10d09-dfac-44ac-b38d-e469d9e75fa3
function SeamAdding1(img, target_height, target_width) 
	# Seams will become smaller than the image in at least one direction. 
	# Adding a vertical seam adds width to the image.
	# After that trying to add a horizontal seam doesn't work
	# since the seam is smaller than the image.
	# All seams are the width or height of the original image.
    img_height, img_width = size(img)
    if target_height <= img_height || target_width <= img_width
        return "Provide a target size greater than the current size of the image"
    end

    n_height = target_height - img_height
    n_width = target_width - img_width
    seamOrder = []

    temp_img = copy(img)
    current_height, current_width = img_height, img_width

    while true
        if abs(current_height - img_height) == n_height
            for _ in 1:(n_width - abs(current_width - img_width))
                energy = edges(temp_img)
                _, seam = FindSeam_X(energy)
                push!(seamOrder, ("x", seam))
                temp_img = RemoveSeam_Y(temp_img, seam)
            end
            break
        elseif abs(current_width - img_width) == n_width
            for _ in 1:(n_height - abs(current_height - img_height))
                energy = edges(temp_img)
                _, seam = FindSeam_Y(energy)
                push!(seamOrder, ("y", seam))
                temp_img = RemoveSeam_X(temp_img, seam)
            end
            break
        else
            energy = edges(temp_img)
            direction, seam = FindSeam(energy)
            push!(seamOrder, (direction, seam))
            if direction == "x"
                temp_img = RemoveSeam_X(temp_img, seam)
                current_height -= 1
            else
                temp_img = RemoveSeam_Y(temp_img, seam)
                current_width -= 1
            end
        end
    end
    
    adjusted_seams = adjust_indices(seamOrder, img_height, img_width)
    
    for (direction, seam) in adjusted_seams
        if direction == "x"
            img = AddSeam_X(img, seam)
        else
            img = AddSeam_Y(img, seam)
        end
    end

    return img
end

# ╔═╡ 57e8bc18-ca90-472b-a2e0-6d5a4d0aed32
function Resize(img, target_height, target_width)
	height, width = size(img)
	if target_height < height && target_width < width
		return SeamCarving(img, target_height, target_width)
		
	elseif target_height > height && target_width > width
		return SeamAdding(img, target_height, target_width)
		
	elseif target_height < height && target_width > width
		img = SeamCarving_X(img, target_height)
		img = SeamAdding_Y(img, target_width)
		return img
	elseif target_height > height && target_width < width
		img = SeamCarving_Y(img, target_width)
		img = SeamAdding_X(img, target_height)
		return img
	end
end

# ╔═╡ 6a7bc37d-e61c-434a-a92e-71dd3e2b677c
resized = Resize(imageToResize, 1100, 1460)

# ╔═╡ 2b75bdb9-668f-4552-a586-1b9604b8a518
size(resized)

# ╔═╡ f2277013-9f05-42ea-8ee0-8a415b5648b4
hbox(imageToResize, resized)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
ImageFiltering = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
OffsetArrays = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
ColorVectorSpace = "~0.10.0"
Colors = "~0.12.10"
FileIO = "~1.16.3"
ImageFiltering = "~0.7.8"
Images = "~0.26.0"
OffsetArrays = "~1.13.0"
Plots = "~1.40.2"
PlutoUI = "~0.7.58"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.3"
manifest_format = "2.0"
project_hash = "c22c6f4551fda6900e203efb84005469239a1841"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "5c9b74c973181571deb6442d41e5c902e6b9f38e"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.12.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceCUDSSExt = "CUDSS"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "f21cfd4950cb9f0587d5067e69405ad2acd27b87"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.6"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "5a97e67919535d6841172016c9530fd69494e5ec"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.6"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a2f1c8c668c8e3cb4cca4e57a8efdb09067bb3fd"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+2"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "71acdbf594aab5bbb2cec89b208c41b4c411e49f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.24.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "05ba0d07cd4fd8b7a39541e31a7b0254704ea581"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.13"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "9ebb045901e9bbf58767a9f34ff89831ed711aae"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.7"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "b8fe8546d52ca154ac556809e10c75e6e7430ac8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.5"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "4b270d6465eb21ae89b732182c20dc165f8bf9f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.25.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[deps.CommonWorldInvalidations]]
git-tree-sha1 = "ae52d1c52048455e85a387fbee9be553ec2b68d0"
uuid = "f70d9fcc-98c5-4d4a-abd7-e4cdeebd8ca8"
version = "1.0.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "b1c55339b7c6c350ee89f2c1604299660525b248"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.15.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "ea32b83ca4fefa1768dc84e504cc0a94fb1ab8d1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.2"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "f9d7112bfff8a19a3a4ea4e03a8e6a91fe8456bf"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.3"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c6317308b9dc757616f0b5cb379db10494443a7"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.2+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "4820348781ae578893311153d69049a93d05f39d"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.8.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "db16beca600632c95fc8aca29890d83788dd8b23"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.96+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "5c1d8ae0efc6c2e7b1fc502cbe25def8f661b7bc"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.2+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1ed150b39aebcc805c26b93a8d0122c940f64ce2"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.14+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "3f74912a156096bd8fdbef211eff66ab446e7297"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "8e2d86e06ceb4580110d9e716be26658effc5bfd"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.8"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "da121cbdc95b065da07fbb93638367737969693f"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.8+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "43ba3d3c82c18d88471cfd2924931658838c9d8f"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.0+4"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "7c82e6a6cd34e9d935e9aa4051b66c6ff3af59ba"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.2+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "ebd18c326fa6cee1efb7da9a3b45cf69da2ed4d9"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.11.2"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HistogramThresholding]]
deps = ["ImageBase", "LinearAlgebra", "MappedArrays"]
git-tree-sha1 = "7194dfbb2f8d945abdaf68fa9480a965d6661e69"
uuid = "2c695a8d-9458-5d45-9878-1b8a99cf7853"
version = "0.3.1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "8e070b599339d622e9a081d17230d74a5c473293"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.17"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[deps.ImageBinarization]]
deps = ["HistogramThresholding", "ImageCore", "LinearAlgebra", "Polynomials", "Reexport", "Statistics"]
git-tree-sha1 = "f5356e7203c4a9954962e3757c08033f2efe578a"
uuid = "cbc4b850-ae4b-5111-9e64-df94c024a13d"
version = "0.3.0"

[[deps.ImageContrastAdjustment]]
deps = ["ImageBase", "ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "eb3d4365a10e3f3ecb3b115e9d12db131d28a386"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.12"

[[deps.ImageCore]]
deps = ["ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "b2a7eaa169c13f5bcae8131a83bc30eff8f71be0"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.2"

[[deps.ImageCorners]]
deps = ["ImageCore", "ImageFiltering", "PrecompileTools", "StaticArrays", "StatsBase"]
git-tree-sha1 = "24c52de051293745a9bad7d73497708954562b79"
uuid = "89d5987c-236e-4e32-acd0-25bd6bd87b70"
version = "0.1.3"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "08b0e6354b21ef5dd5e49026028e41831401aca8"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.17"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "PrecompileTools", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "432ae2b430a18c58eb7eca9ef8d0f2db90bc749c"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.8"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "437abb322a41d527c197fa800455f79d414f0a3c"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.8"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils"]
git-tree-sha1 = "8e2eae13d144d545ef829324f1f0a5a4fe4340f3"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.3.1"

[[deps.ImageMagick_jll]]
deps = ["Artifacts", "Ghostscript_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "OpenJpeg_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "8d2e786fd090199a91ecbf4a66d03aedd0fb24d4"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.11+4"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.ImageMorphology]]
deps = ["DataStructures", "ImageCore", "LinearAlgebra", "LoopVectorization", "OffsetArrays", "Requires", "TiledIteration"]
git-tree-sha1 = "6f0a801136cb9c229aebea0df296cdcd471dbcd1"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.4.5"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "PrecompileTools", "Statistics"]
git-tree-sha1 = "783b70725ed326340adf225be4889906c96b8fd1"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.7"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "3ff0ca203501c3eedde3c6fa7fd76b703c336b5f"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.8.2"

[[deps.ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "3b5344bcdbdc11ad58f3b1956709b5b9345355de"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.8"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "e0884bdf01bbbb111aea77c348368a86fb4b5ab6"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.10.1"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageBinarization", "ImageContrastAdjustment", "ImageCore", "ImageCorners", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "12fdd617c7fe25dc4a6cc804d657cc4b2230302b"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.26.1"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0936ba688c6d201805a83da835b55c61a180db52"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.11+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "be8e690c3973443bec584db3346ddc904d4884eb"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "14eb2b542e748570b56446f4c50fbfb2306ebc45"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.2.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "88a101217d7cb38a7b481ccd50d21876e1d1b0e0"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.15.1"
weakdeps = ["Unitful"]

    [deps.Interpolations.extensions]
    InterpolationsUnitfulExt = "Unitful"

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "PrecompileTools", "Reexport", "Requires", "TranscodingStreams", "UUIDs", "Unicode"]
git-tree-sha1 = "5fe858cb863e211c6dedc8cce2dc0752d4ab6e2b"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.50"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "fa6d0bcff8583bac20f1ffa708c3913ca605c611"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.5"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c84a835e1a09b289ffcd2271bf2a337bbdda6637"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.3+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "70c5da094887fd2cae843b8db33920bac4b6f07d"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "5b0d630f3020b82c0775a51d05895852f8506f50"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.4"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "a9eaadb366f5493a5654e843864c13d8b107548c"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.17"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "9fd170c4bbfd8b935fdc5f8b7aa33532c991a673"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.11+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fbb1f2bef882392312feb1ede3615ddc1e9b99ed"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.49.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0c4f9c4f1a50d8f35048fa0532dabbadf702f81e"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.1+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "5ee6203157c120d79034c748a2acba45b82b8807"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.1+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LittleCMS_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg"]
git-tree-sha1 = "110897e7db2d6836be22c18bffd9422218ee6284"
uuid = "d3a379c0-f9a3-5b72-a4c0-6bf4d2e8af0f"
version = "2.12.0+0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a2d09619db4e765091ee5c6ffe8872849de0feea"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.28"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "8084c25a250e00ae427a379a5b607e7aed96a2dd"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.171"

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.LoopVectorization.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "f046ccd0c6db2832a9f639e2c669c6fe867e5f4f"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "1130dbe1d5276cb656f6e1094ce97466ed700e5a"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "91a67b4d73842da90b526011fa85c5c4c9343fe0"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.18"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "6a731f2b5c03157418a20c12195eb4b74c8f8621"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.13.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "8292dd5c8a38257111ada2174000a33745b06d4e"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.2.4+0"

[[deps.OpenJpeg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libtiff_jll", "LittleCMS_jll", "Pkg", "libpng_jll"]
git-tree-sha1 = "76374b6e7f632c130e78100b166e5a48464256f8"
uuid = "643b3616-a352-519d-856d-80112ee9badc"
version = "2.4.0+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a12e56c72edee3ce6b96667745e6cbbe5498f200"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.23+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "67186a2bc9a90f9f85ff3cc8277868961fb57cbd"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.3"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "35621f10a7531bc8fa58f74610b1bfb70a3cfc6b"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.43.4+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "6e55c6841ce3411ccb3457ee52fc48cb698d6fb0"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.2.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "7b1a9df27f072ac4c9c7cbe5efb198489258d1f5"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "082f0c4b70c202c37784ce4bfbc33c9f437685bf"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.5"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "645bed98cd47f72f67316fd42fc47dee771aefcd"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.2"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase"]
git-tree-sha1 = "3aa2bb4982e575acd7583f01531f241af077b163"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.2.13"

    [deps.Polynomials.extensions]
    PolynomialsChainRulesCoreExt = "ChainRulesCore"
    PolynomialsMakieCoreExt = "MakieCore"
    PolynomialsMutableArithmeticsExt = "MutableArithmetics"

    [deps.Polynomials.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    MakieCore = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
    MutableArithmetics = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "80686d28ecb3ee7fb3ac5371cacaa0d673eb0d4a"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.1"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "994cc27cdacca10e68feb291673ec3a76aa2fae9"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.6"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "5680a9276685d392c87407df00d57c9924d9f11e"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.7.1"
weakdeps = ["RecipesBase"]

    [deps.Rotations.extensions]
    RotationsRecipesBaseExt = "RecipesBase"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "2803cab51702db743f3fda07dd1745aadfbf43bd"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.5.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "456f610ca2fbd1c14f5fcf31c6bfadc55e7d66e0"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.43"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "4b33e0e081a825dbfaf314decf58fa47e53d6acb"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.4.0"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Static]]
deps = ["CommonWorldInvalidations", "IfElse", "PrecompileTools"]
git-tree-sha1 = "87d51a3ee9a4b0d2fe054bdd3fc2436258db2603"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "1.1.1"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Requires", "SparseArrays", "Static", "SuiteSparse"]
git-tree-sha1 = "8963e5a083c837531298fc41599182a759a87a6d"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.5.1"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "eeafab08ae20c62c44c8399ccb9354a04b80db50"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.7"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "SIMD", "UUIDs"]
git-tree-sha1 = "bc7fd5c91041f44636b2c134041f7e5263ce58ae"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.10.0"

[[deps.TiledIteration]]
deps = ["OffsetArrays", "StaticArrayInterface"]
git-tree-sha1 = "1176cc31e867217b06928e2f140c90bd1bc88283"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.5.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "60df3f8126263c0d6b357b9a1017bb94f53e3582"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.0"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "dd260903fdabea27d9b6021689b3cd5401a57748"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.20.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "975c354fcd5f7e1ddcc1f1a23e6e091d99e99bc8"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.4"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "e7f5b81c65eb858bed630fe006837b935518aca5"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.70"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "93f43ab61b16ddfb2fd3bb13b3ce241cafb0e6c9"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.31.0+0"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "d9717ce3518dc68a99e6b96300813760d887a01d"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.1+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "a54ee957f4c86b526460a720dbc882fa5edcbefc"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.41+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d2d1a5c49fae4ba39983f63de6afcbea47194e85"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+0"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "47e45cd78224c53109495b3e324df0c37bb61fbe"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+0"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "bcd466676fef0878338c61e655629fa7bbc69d8e"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e678132f07ddb5bfa46857f0d7620fb9be675d3b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1827acba325fdcdf1d2647fc8d5301dd9ba43a9d"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.9.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7015d2e18a5fd9a4f47de711837e980519781a4"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.43+1"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7d0ea0f4895ef2f5cb83645fa689e52cb55cf493"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2021.12.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─b0cb3a8b-b8d5-4414-8c64-de5769384fe5
# ╠═67a5c9fd-f688-471b-9aca-afd5629e9350
# ╠═7dc830d6-72f6-4c39-9206-20d7f7f64172
# ╠═4b6e3ac6-a7c3-4975-9768-7a55c96b55cd
# ╠═8cce9062-dc2d-4999-ac9f-725e43437f2d
# ╟─96fc3794-d94c-4820-9aff-74bc060754d6
# ╠═3125c143-f6fd-4aa0-a194-ed7e5ec8eb9b
# ╟─b5ed6c4d-f7c7-40d9-9ab1-517a384fac44
# ╟─7fe25220-d7c2-4ef4-a1b2-8056a784e14c
# ╟─42ccd340-51f2-405a-8d79-91a3faa569b4
# ╟─41a3399d-f606-47da-92ce-1da92b0f2692
# ╟─69c94c03-5f6c-4fc8-9ae9-64813a1d5a31
# ╠═93d20de9-cd4d-4a47-92b5-f78bd2e80781
# ╠═761d8a4f-f508-4d15-bc04-65f1a10b0196
# ╠═e4253e05-4512-4282-9337-6069d35ddebb
# ╠═ac815971-3ff2-4afc-b4b0-7382c9b5dd74
# ╠═63d2c6cf-c39c-4076-9641-8e548d4d37d0
# ╠═589c2ca0-e9d8-40d9-8e65-2170cbd75aef
# ╟─4d10ee5d-2355-4a92-8838-fc85737b28e4
# ╠═b50d7a3a-b980-4a0a-9515-abab70e93370
# ╟─ad78688a-20b1-46bd-94cc-5dd5ab1c4a51
# ╠═83cb7719-0a9a-4957-93e2-fa59ab1b00d5
# ╠═a6586b85-30df-4f9e-8d2a-07dd6f9a2679
# ╟─f69b9f69-37ac-4c79-9083-c37e2c34e1d8
# ╟─01d73ebe-277d-4fba-b680-0f87b8cc5280
# ╟─05d87004-209a-4198-b62b-f3285e5d1166
# ╠═a61b28d1-3cc0-439d-bd41-e791dc0ee21d
# ╠═d7abf0c7-4ca8-4530-adbc-189196fdba92
# ╠═b277e483-f577-40d8-a57b-93513621a0e9
# ╟─1860775b-94e0-4479-b3e8-6bfed9396cf3
# ╟─2c63b06f-1a90-445c-ba3c-485ef5110dc2
# ╟─582e0e2e-a796-4c7c-bff9-848c6fedb46f
# ╠═4621e53c-07ba-4e55-ab68-205353156181
# ╟─6215b5c6-82bb-48e4-ae42-d02d4b6f3132
# ╟─69ae0195-5726-405e-9cf8-fbdd30c0d3eb
# ╠═76b12046-e63d-4c85-9bf0-9fc95bba7391
# ╟─8fd5a173-3efe-4554-955c-f1281323dd9f
# ╟─d828b425-051e-4e75-8bda-e27ba8bc4ed6
# ╟─28dafdf8-4ed1-48cf-9fe2-6b669ed16aba
# ╟─b2b8ec59-f073-4faf-a549-4a0cca54348e
# ╟─886d4189-651a-47b1-ad89-6b7e2a684978
# ╟─b9eda326-f335-4566-aa6b-a4d25e5f8d2a
# ╠═b6426840-25cf-4f08-9c1d-604ffbd540c8
# ╠═fe6f830b-c2d7-4317-b647-27a6858cc2f3
# ╠═67db4cf2-be2b-437c-bcb7-0de160d551fc
# ╠═066049e4-d67a-4765-9e92-1c5a408ccbdd
# ╟─7caad4de-77de-40b2-ac6f-2c2049809aa9
# ╠═6f51fcf5-05c3-49b1-9614-3994fe8a0e98
# ╠═285ee5e9-ef8f-40c7-bde5-94e6eeae7a12
# ╠═df7e85d0-ad1f-45e6-bbc2-549d7a6dda73
# ╠═701229cb-d560-42e9-a1ab-8ab11b7ade07
# ╠═9d4aa7a5-d042-459e-a9c2-50ac933fa3bc
# ╠═04a7dd6f-0ee1-43ff-8c07-363736d9749a
# ╠═84594768-a00f-45d3-9734-a6a496435f6b
# ╠═952fd123-be34-42c8-ac46-ff2778f69349
# ╠═fff7b18e-a0d6-4bfb-bd52-b7bd3f3fd545
# ╠═89a789ad-bdf5-44cf-a9ac-2e0b73cb590d
# ╠═b1e2539c-3789-4e70-ab2e-a52d865daf85
# ╠═a3ce16b4-19a6-4cc9-bede-5b2fcc59e738
# ╟─3e188be8-08c5-4b60-abd6-cc9814dddf8b
# ╠═dd3d5889-6b31-48da-8b6f-e4e3c1746c62
# ╟─d4e755d4-c976-4158-80af-08fdae6bf530
# ╠═f89a4815-2606-49a3-bded-28b1bfdfcb15
# ╠═9f2f2da0-a054-4080-bda9-28a092af6f40
# ╟─751612f3-d160-4c2d-beb6-503acd6ff1cc
# ╟─0e12ebbf-f7a4-49d8-8d3a-8713e1703a44
# ╠═98df5eda-0369-4250-bc3d-870933402aac
# ╟─af1211a4-8cfe-4094-b6ee-61426651361a
# ╟─8170e45d-9436-41c6-98f1-3c8fbbf42e5f
# ╠═4b65334f-57b3-4708-a944-765915e363ef
# ╟─0570e1fd-6cb9-43cc-bbf3-da91d6c30ee4
# ╠═a8fc675e-9a2a-4efa-84d3-a5ee8dd74ce4
# ╠═6ae230e8-af2c-47de-b884-64119b106e1a
# ╠═e333cc9c-cbf2-4a57-b09f-c2333c97eabe
# ╠═dd2725de-1d81-4262-91ea-6c2df5e11495
# ╠═0edbf691-6e01-4bce-9ed8-e712eb37ca1d
# ╟─78d7f0e8-60a6-427d-93cd-666672298d0c
# ╟─4eaeba26-316b-4edd-a580-c3b218d3826b
# ╟─49b41bfe-850f-4ca6-9190-f3cb6432a506
# ╟─3e7887d9-0165-4a73-a97c-5a49274d56f0
# ╟─907dff8c-fa1b-4130-b96b-630bc42acb7f
# ╠═ecb6ed97-8590-4101-8df1-9a598f734892
# ╟─046f2d5c-11ff-450c-a4cf-3eeacb3cd9d6
# ╟─ff6137eb-43b1-43c2-aa93-b6ee4d622445
# ╟─2593f350-550b-41a1-885f-a3c2632c1b43
# ╠═b8e2adc5-4f63-4ec1-8395-874297b7c27f
# ╠═0ccdd4a3-e8db-4d24-8da9-629cea9c7479
# ╠═4ea5da47-e0e2-4b5d-bb50-d9105e9e63a2
# ╟─5ee5d537-a9a9-4f00-86fe-8ffd52347d24
# ╠═20cd3f94-796e-4488-af50-d8a6a45119d3
# ╠═9c131970-d45c-4f51-86cd-6cf6f3f4718a
# ╟─22ad9ba6-7d35-420a-a7d1-52ea948134e6
# ╠═8b7ad2c5-2fc3-4e16-bb47-6b60bdc40083
# ╟─34f7b8ed-813f-4afd-aa61-88471db1714e
# ╟─e6ccde94-7e14-482a-b97f-4fb764674eae
# ╟─cf641a29-14cd-411f-b0e4-86164cfa54ad
# ╠═140b40e3-745d-4379-978d-fd7854a97c2d
# ╟─879ed4d3-a846-4ea9-b3c7-f17f9518fe29
# ╠═7238526e-b1c9-4aac-a97b-139c53138803
# ╟─241c6fc4-d556-446a-ac0a-871b1bc1709c
# ╟─e3e86596-6604-46f9-a6df-82ef7ee21ebb
# ╠═9efde71a-6a45-4c2c-a7ab-236fdc07c549
# ╟─e034819e-2f97-460f-a8d0-f0901ddfd40e
# ╟─f3a45e02-2467-4e1a-b7d8-33b004dc2b97
# ╟─57cf5b1e-5d33-448d-a672-b06e7318a51a
# ╟─7b828088-0906-46fd-b9c3-25516b577808
# ╟─e093acf2-c092-4f39-83bb-ea5bf050c82c
# ╟─3b7789af-ccfd-4616-af05-be9e35f3a2ec
# ╠═b483ca6d-0125-419a-839d-09972c293949
# ╠═6a7bc37d-e61c-434a-a92e-71dd3e2b677c
# ╠═2b75bdb9-668f-4552-a586-1b9604b8a518
# ╟─f2277013-9f05-42ea-8ee0-8a415b5648b4
# ╟─baa9b63d-7109-4c1d-9251-2689daab0b8f
# ╠═16ed7e4e-f70e-11ee-29ca-9d31a0704ed2
# ╟─7a21d992-dcac-42e0-867e-2348e54b7018
# ╟─f175daa0-ea50-4e99-821c-f916756d8222
# ╟─7a22b815-f79e-4648-89be-7d0a1be3ee4d
# ╟─4bacc97c-e169-406a-ac0e-b17495cbd33e
# ╟─a92b71eb-38f4-4e12-a86f-634bac10d03f
# ╟─fd498b6c-6dee-416a-9bfa-fb1132526dfe
# ╟─cc76745a-a351-489e-a2ab-b98e1e96fd09
# ╟─0960477a-0442-4e4d-b265-9f5e9babda86
# ╟─5a44377c-6f5c-47c8-9ac8-bf5412df97b1
# ╟─0c5ae1af-ba26-4341-b7d9-59c3c0fdd7dc
# ╟─d91deb0f-ea8a-4d88-b94e-bcb8baa9f5b3
# ╟─03a4da3d-8456-4cf3-8af8-172288b6a326
# ╟─e1a6ae2e-6df3-4375-89f2-512fc60a9199
# ╟─132238d6-fb35-4692-9fff-0f95024f44c8
# ╟─b64a9c4c-5619-4e74-8d35-913850e91184
# ╟─9e4c1c18-cab2-441f-8550-35f5e9b4df30
# ╟─7b31abbd-8f3a-4b12-b9fd-949be9fc9b3c
# ╟─78777334-b791-4dab-8624-7e87bd4eeb5c
# ╠═2022992c-714c-440d-8c30-8f0038ff317e
# ╟─2c7dc971-641c-423e-8f57-e03891959be3
# ╟─7783364a-3d48-485b-92c4-532a3306cb9c
# ╟─0396b46a-7070-498b-8c59-605f4fe30a9d
# ╟─76360fb4-5678-4a53-8f14-03ad16c26a83
# ╟─fb5de843-f7b5-40ac-a822-0079033bd9c9
# ╟─26b22c6f-8305-4114-8f95-5969a69ffff6
# ╟─3c502d3f-7131-4d4f-87b6-9f3c2e20f94a
# ╟─88baaa6e-51a9-4c38-b753-09bdd389bb11
# ╟─ac073bb7-6c08-4d5a-b533-c521b0f7a8d3
# ╟─eeb5a65f-1a4a-4440-8d9d-ac0e2b01eefe
# ╟─d5c667c3-6c48-414d-9ad5-e3962550a8f0
# ╟─4735c79e-00cc-45f1-b367-d2aba418985c
# ╟─54a174ba-4210-420f-b5e9-2ad0f4f254e0
# ╟─437d0bb0-4c9f-4550-a709-25e29bc5f42c
# ╟─59ea916b-974d-49ec-876c-837193664058
# ╠═91a52719-187a-4967-9c2d-78a965bc4da1
# ╠═9c461725-fc55-4d28-835a-fbf3831cf06d
# ╠═8154e276-3258-4ec4-aca1-1b73f3c3c4e6
# ╠═a7ecf354-59aa-40fb-bfae-beb200664a91
# ╠═07ae1e36-46f4-4372-8f23-28c8b31a2d1a
# ╠═6e6740b0-13c2-4925-ba86-654c3093f977
# ╠═e920d8bb-300a-4445-ba78-d9d57842627d
# ╠═cf1766bf-49ef-422c-99fa-9123efe00485
# ╠═75d03671-c3f0-4049-bb80-d3e2537def12
# ╠═8b58ab34-18e4-4d92-b52e-bad87cae91e4
# ╠═77fc6bb2-2878-428c-8c08-f3778da2c4ee
# ╠═b698e689-7e30-4846-afbf-e5c0f3873b6c
# ╠═9eb10d09-dfac-44ac-b38d-e469d9e75fa3
# ╠═57e8bc18-ca90-472b-a2e0-6d5a4d0aed32
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
