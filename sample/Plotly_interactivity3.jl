### A JIVEbook.jl notebook ###
# v0.0.2

using Markdown
using InteractiveUtils
using JIVECore
using PlutoPlotly, PlutoUI
import Main.PlutoRunner.JIVECore.Data.image_data as image_data
import Main.PlutoRunner.JIVECore.Data.image_keys as image_keys

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 2a28f754-1ece-4dc3-8c96-59ced8aa21a5
using JSON

# ╔═╡ b97d90ae-22e4-458e-aeff-a8dc042b33fd
using Random

# ╔═╡ 893b2f38-0577-438f-bc38-2b747f0d51a9
using ImageCore

# ╔═╡ b870cc30-11a7-49a6-a280-fc18f7baecba
Random.seed!(42)
	
N = 100
random_x = range(0, stop=1, length=N)
random_y0 = randn(N) .+ 5
random_y1 = randn(N)
random_y2 = randn(N) .- 5

plot([
	scatter(x=random_x, y=random_y0, mode="markers", name="markers"),
	scatter(x=random_x, y=random_y1, mode="lines", name="lines"),
	scatter(x=random_x, y=random_y2, mode="markers+lines", name="markers+lines")
])

# ╔═╡ e95c47b7-ebdd-483f-a154-2e1e4f0e3312
md"""
Change the number of points:

$(@bind M Slider(1:10:100))
"""

# ╔═╡ cca6dcc6-56cd-4ba4-9deb-3383e29e32f8
pp = Plot(scatter3d(x = rand(M), y = rand(M), z = rand(M), mode="markers"), Layout(
	uirevision = 1,
	scene = attr(
		xaxis_range = [-1,2],
		yaxis_range = [-1,2],
		zaxis_range = [-1,2],
		aspectmode = "cube",
	),
	height = 550
	# autosize = true,
));


# ╔═╡ bea0617d-e73c-4fd2-9207-dde21487076d

	p = PlutoPlot(pp)
	add_plotly_listener!(p, "plotly_relayout", htl_js("""
	(e) => {

	console.log(e)
	//console.log(PLOT._fullLayout._preGUI)
    
    
	var eye = e['scene.camera']?.eye;

    if (eye) {
		console.log('update: ', eye);
	} else {
		console.log(e)
	}
	console.log('div: ',PLOT._fullLayout.scene.camera.eye)
   	console.log('plot_obj: ',plot_obj.layout.scene?.camera?.eye)
	
}
	"""))
	PlutoPlotly._show(p)


# ╔═╡ 036f6983-6b40-4b36-9392-1e156efc847e
@bind hover let
	p = plot(scatter(y = rand(10), name = "test", showlegend=true))
	add_plotly_listener!(p,"plotly_hover", "
	(e) => {

	console.log(e)
    let dt = e.points[0]
	PLOT.value = [dt.x, dt.y]
	PLOT.dispatchEvent(new CustomEvent('input'))
}
	")
	p
end


# ╔═╡ 7875db07-5633-41b8-b066-5483f36599c2
hover

# ╔═╡ fd64b027-f1bf-435d-adf7-a1f79ed74960
@bind selection let
	p = (plot(scatter(y = rand(10), name = "test", showlegend=true)))
	add_plotly_listener!(p,"plotly_selected", "
	(e) => {

	console.log(e)
    let dt = e.selections[0]
	PLOT.value = {shape: dt.type, x0: dt.x0, x1: dt.x1, y0: dt.y0, y1: dt.y1}
	PLOT.dispatchEvent(new CustomEvent('input'))
}
	")
	p
end

# ╔═╡ f1271e3d-e439-4f0a-a368-16817de18ec5
selection

# ╔═╡ ef404439-0035-4b5a-b8d5-02ba6b873d76
points = [(rand(),rand()) for _ in 1:10000]

# ╔═╡ 0f4024fc-deef-4376-adaf-106c3e848df0
@bind limits let
	p = Plot(
		scatter(x = first.(points), y = last.(points), mode = "markers")
	)|> PlutoPlot
	add_plotly_listener!(p, "plotly_relayout", "
	e => {
	console.log(e)
	let layout = PLOT.layout
	let asd = {xaxis: layout.xaxis.range, yaxis: layout.yaxis.range}
	PLOT.value = asd
	PLOT.dispatchEvent(new CustomEvent('input'))
	}
	")
end

# ╔═╡ b421dadf-d9f5-4666-b619-deeaeb97eb5b
limits

# ╔═╡ 279b396b-7a69-408f-8326-dec475cf7dba
visible_points = let
	if ismissing(limits)
		points
	else
		xrange = limits["xaxis"]
		yrange = limits["yaxis"]
		func(x,y) = x >= xrange[1] && x <= xrange[2] && y >= yrange[1] && y <= yrange[2]
		filter(x -> func(x...), points)
	end
end

# ╔═╡ 081f4ff8-fc8d-40af-975a-546d5569a7bc
length(visible_points)

# ╔═╡ 40db5dbd-63f4-4caf-8128-692fc75a195d
# Add image
img_width = 1600
img_height = 900
scale_factor = 1

trace1 = scatter(
        x=[0, img_width * scale_factor],
        y=[0, img_height * scale_factor],
        mode="markers",
        marker_opacity=0
    )

layout = Layout(
    xaxis = attr(showgrid=false, range=(0,img_width)),
    yaxis = attr(showgrid=false, scaleanchor="x", range=(img_height, 0)),
    images=[
        attr(
            x=0,
            sizex=img_width,
            y=0,
            sizey=img_height,
            xref="x",
            yref="y",
            opacity=1.0,
            layer="below",
            source="https://raw.githubusercontent.com/michaelbabyn/plot_data/master/bridge.jpg"
        )
    ],
    dragmode="drawrect",
    newshape=attr(line_color="cyan"),
    title_text="Drag to add annotations - use modebar to change drawing tool",
    modebar_add=[
        "drawline",
        "drawopenpath",
        "drawclosedpath",
        "drawcircle",
        "drawrect",
        "eraseshape"
    ],
)

qq = Plot(trace1,layout)

# ╔═╡ fb72ca61-70e1-4df7-a5ec-5bc992bb444d
md"""
$(
@bind obs let
	q = PlutoPlot(qq)
	add_plotly_listener!(q,"plotly_relayout", "
 function(e){
	console.log(e)
	let s = e.shapes
  let dt = s[s.length-1]
	PLOT.value = {shape: dt.type, x0: dt.x0, x1: dt.x1, y0: dt.y0, y1: dt.y1}
	PLOT.dispatchEvent(new CustomEvent('input'))
}
	")
	q
end
)
"""

# ╔═╡ e35931a8-5fa3-4465-a2f5-0926c283233e
obs

# ╔═╡ 8bd35949-00c2-4c70-956a-4e9fdf497f54
p2 = PlutoPlot(Plot(rand(10), Layout(uirevision = 1)))
add_plotly_listener!(p2, "plotly_relayout", htl_js("""
function(e) {
console.log(PLOT) // logs the plot div inside the developer console
}
"""))

# ╔═╡ ceaff868-35da-4e93-8068-eeb4e3fa5325
image_data[JIVECore.Files.loadImage!(image_data, image_keys)]


# ╔═╡ 7a0e461b-0f9b-45c9-a795-ece42572e074
b = Gray.(image_data["blobs"])

# ╔═╡ c45d81d8-ebc3-4a49-92a3-9c6e3d6f9b41
h = plot(heatmap(z=Float32.(b),colorscale="Greys"),Layout(template=templates.presentation, yaxis = attr(showgrid=false, scaleanchor="x")))

# ╔═╡ a197f528-1dd9-4b72-b631-24d7efb6b27b
PlutoPlotly.templates

# ╔═╡ ecb1c939-0167-4014-a0a7-8d5e52d373d5


# ╔═╡ fbc54fcf-c451-4172-841d-0dcdff6eeeba
# Add image
function create_plotly(r)
img_width2, img_height2 = size(r)

trace2 = heatmap(z=Float32.(Gray.(r)),colorscale="Greys")

layout2 = Layout(
		template=templates.seaborn,
    xaxis = attr(showgrid=false, range=(0,img_width2)),
    yaxis = attr(showgrid=false, scaleanchor="x", range=(img_height2, 0)),
    dragmode="drawrect",
    newshape=attr(line_color="cyan"),
    # title_text="Drag to add annotations - use modebar to change drawing tool",
    modebar_add=[
        "drawline",
        "drawopenpath",
        "drawclosedpath",
        "drawcircle",
        "drawrect",
        "eraseshape"
    ],
)

plot(trace2,layout2)

end

# ╔═╡ f993b93f-f901-46db-ad21-827a91d910a0
function create_plotly_listener(q)
add_plotly_listener!(q,"plotly_relayout", "
		 function(e){
				console.log(e)
				if (e.hasOwnProperty('shapes')){
						let s = e.shapes
					  let dt = s[s.length-1]
						PLOT.value = {shape: dt.type, x0: dt.x0, x1: dt.x1, y0: dt.y0, y1: dt.y1}
						PLOT.dispatchEvent(new CustomEvent('input'))
				} else {
						console.log(Object.getOwnPropertyNames(e))
						let sh = Object.getOwnPropertyNames(e)[0]
						let xy = Object.values(e)
						PLOT.value = {shape: sh, x0: xy[0], x1: xy[1], y0: xy[2], y1: xy[3]}
						PLOT.dispatchEvent(new CustomEvent('input'))
				}
				
		}
	")
end

# ╔═╡ c36d8482-d2bd-4c36-b9ce-aadfe6e0d60e
md"""
#####
##### Annotation Tool
---

1. Choose image: $(@bind r Select(image_keys, default=image_keys[end]) ) 
1. Select Area 
1. Choose operation: $(@bind s confirm(Select([1 => "crop", 2 => "fill", 3 => "plot"])) )

---

$(
@bind obs2 let
	q = create_plotly(image_data[r])
	create_plotly_listener(q)
	q
end
)
---


Apply last operation to the selected images (press Ctrl to select multiple items):

$(@bind rr confirm(MultiSelect(image_keys)) )"

"""

# ╔═╡ 192dc6eb-82f7-4dde-ad5f-0a77f22fdabb
obs2

# ╔═╡ 391341a8-706e-4234-977e-66ff25e78033
a = Dict()

# ╔═╡ a4032867-0a88-45bc-aa11-84513a736655
JIVECore.Data.keyCheck(a,"1")

# ╔═╡ 8866d672-9749-4572-a1dd-b0cea7bbe49e
s

# ╔═╡ e1126e1a-141d-4b6f-aa3d-be9b50b356fd
function pass_plotly_shape(shapes_dict::Dict, d::Dict)
    return nothing
end

# ╔═╡ 8eb95696-7c71-4f6a-9d42-19f5b7430049

function create_plotly_shape!(shapes_dict::Dict, d::Dict)
    key = JIVECore.Data.keyCheck(shapes_dict,"0")
    shapes_dict[key] = d
end

# ╔═╡ 4542915a-7f0c-4ee4-be5d-0a97579c4d68
a

# ╔═╡ 973e3aac-0c98-4a5d-9fcc-02b0fee71a2e
function modify_plotly_shape!(shapes_dict::Dict, d::Dict)
    key = split(split(obs2["shape"],"[")[2],"]")[1]
    d["shape"] = shapes_dict[key]["shape"]
    shapes_dict[key] = d
end

# ╔═╡ bc571dfa-0597-4f74-990e-126cf0b1f9b9
function record_plotly_shapes(shape::String)
    
    shapes = Dict(
        "rect" => create_plotly_shape!,
        "circ" => create_plotly_shape!,
        "line" => create_plotly_shape!,
        "shap" => modify_plotly_shape!,
    )
    
    get(shapes, shape[1:4]) do
        return pass_plotly_shape
    end
end

# ╔═╡ ba15339b-6ebf-4e47-a5ea-ee7150d98dec
record_plotly_shapes(obs2["shape"])

# ╔═╡ e9d12ff9-0caa-4d60-8921-6347c5a72842
record_plotly_shapes(obs2["shape"])(a,obs2)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ImageCore = "a09fc81d-aa75-5fe9-8630-4744c3626534"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
ImageCore = "~0.10.1"
JSON = "~0.21.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.4"
manifest_format = "2.0"
project_hash = "8c0d6877100e5839bde24e4df69ab213f9c8c369"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "c7acce7a7e1078a20a285211dd73cd3941a871d6"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.12.0"

    [deps.ColorTypes.extensions]
    StyledStringsExt = "StyledStrings"

    [deps.ColorTypes.weakdeps]
    StyledStrings = "f489334b-da3d-4c2e-b8f0-e476e12c162b"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "8b3b6f87ce8f65a2b4f857528fd8d70086cd72b1"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.11.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "64e15186f0aa277e174aa81798f7eb8598e0157e"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.ImageCore]]
deps = ["ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "8c193230235bbcee22c8066b0374f63b5683c2d3"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.5"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.OffsetArrays]]
git-tree-sha1 = "5e1897147d1ff8d98883cda2be2187dcf57d8f0c"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.15.0"

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

    [deps.OffsetArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

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
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"
"""

# ╔═╡ Cell order:
# ╠═2a28f754-1ece-4dc3-8c96-59ced8aa21a5
# ╠═b97d90ae-22e4-458e-aeff-a8dc042b33fd
# ╟─b870cc30-11a7-49a6-a280-fc18f7baecba
# ╟─e95c47b7-ebdd-483f-a154-2e1e4f0e3312
# ╟─cca6dcc6-56cd-4ba4-9deb-3383e29e32f8
# ╟─bea0617d-e73c-4fd2-9207-dde21487076d
# ╠═036f6983-6b40-4b36-9392-1e156efc847e
# ╠═7875db07-5633-41b8-b066-5483f36599c2
# ╠═fd64b027-f1bf-435d-adf7-a1f79ed74960
# ╠═f1271e3d-e439-4f0a-a368-16817de18ec5
# ╠═ef404439-0035-4b5a-b8d5-02ba6b873d76
# ╠═0f4024fc-deef-4376-adaf-106c3e848df0
# ╠═b421dadf-d9f5-4666-b619-deeaeb97eb5b
# ╠═279b396b-7a69-408f-8326-dec475cf7dba
# ╠═081f4ff8-fc8d-40af-975a-546d5569a7bc
# ╠═40db5dbd-63f4-4caf-8128-692fc75a195d
# ╠═fb72ca61-70e1-4df7-a5ec-5bc992bb444d
# ╠═e35931a8-5fa3-4465-a2f5-0926c283233e
# ╟─8bd35949-00c2-4c70-956a-4e9fdf497f54
# ╠═893b2f38-0577-438f-bc38-2b747f0d51a9
# ╠═ceaff868-35da-4e93-8068-eeb4e3fa5325
# ╠═7a0e461b-0f9b-45c9-a795-ece42572e074
# ╠═c45d81d8-ebc3-4a49-92a3-9c6e3d6f9b41
# ╠═a197f528-1dd9-4b72-b631-24d7efb6b27b
# ╠═ecb1c939-0167-4014-a0a7-8d5e52d373d5
# ╠═fbc54fcf-c451-4172-841d-0dcdff6eeeba
# ╠═f993b93f-f901-46db-ad21-827a91d910a0
# ╠═c36d8482-d2bd-4c36-b9ce-aadfe6e0d60e
# ╠═192dc6eb-82f7-4dde-ad5f-0a77f22fdabb
# ╠═391341a8-706e-4234-977e-66ff25e78033
# ╠═a4032867-0a88-45bc-aa11-84513a736655
# ╠═8866d672-9749-4572-a1dd-b0cea7bbe49e
# ╠═e1126e1a-141d-4b6f-aa3d-be9b50b356fd
# ╠═8eb95696-7c71-4f6a-9d42-19f5b7430049
# ╠═4542915a-7f0c-4ee4-be5d-0a97579c4d68
# ╠═bc571dfa-0597-4f74-990e-126cf0b1f9b9
# ╠═973e3aac-0c98-4a5d-9fcc-02b0fee71a2e
# ╠═ba15339b-6ebf-4e47-a5ea-ee7150d98dec
# ╠═e9d12ff9-0caa-4d60-8921-6347c5a72842
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
