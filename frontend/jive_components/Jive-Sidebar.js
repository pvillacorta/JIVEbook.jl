// @ts-nocheck
/*
    Add Sidebar
*/
// add style file
function addCss(fileName) {
    var head = document.head
    var link = document.createElement("link")

    link.type = "text/css"
    link.rel = "stylesheet"
    link.href = fileName

    head.appendChild(link)
}

addCss("./jive_components/jive.css")

// CONSTANTS
const timeoutValue = 1000

// make space for sidebar
const frameDiv = document.getElementById("frame")
// @ts-ignore
frameDiv.style = `
    margin-left: var(--sidebar-width);
    `

/////////////// open button in navbar ////////////////////
const openButton = document.createElement("button")
openButton.className = "jv-button-nav jv-large"
openButton.title = "Open JIVE Sidebar"
openButton.innerHTML = '<span> <img width="50" src="./img/jive_logo.png"></img> </span>'
openButton.style.visibility = "hidden"
openButton.style.opacity = "1"
openButton.style.left = "0rem"
openButton.onclick = w3_open

const navbar = document.querySelector("#at_the_top")
navbar?.prepend(openButton)

const sideBar = document.createElement("div")
sideBar.id = "sidebar"
sideBar.className = "jv-sidebar jv-bar-block jv-collapse-2 jv-light-grey jv-card" // jv-animate-left

// @ts-ignore
frameDiv.before(sideBar)

// CLOSE BTN
const closeBtn = document.createElement("button")
closeBtn.className = "jv-button"
closeBtn.innerHTML = "<a>×</a>"
closeBtn.style.position = "absolute"
closeBtn.style.top = "0"
closeBtn.style.right = "0px"
closeBtn.title = "Close Sidebar"
closeBtn.onclick = w3_close

// TITLE
const titleDiv = document.createElement("div")
titleDiv.className = "jv-container "
titleDiv.innerHTML = '<h2> <img width="50"  src="./img/jive_logo.png"></img>  </h2> <md-block> ###### v.0.0  \n --- </md-block>'
titleDiv.style.textAlign = "center"

// SEARCH BAR
const searchItem = document.createElement("input")
searchItem.className = "jv-input jv-padding"
searchItem.type = "search"
searchItem.placeholder = "Search..."
searchItem.id = "sideBarInput"
searchItem.style.cssText = `
            border-radius: 12px;
            margin: 10% auto 10% 2.5%;
        `
searchItem.onkeyup = function () {
    var input, filter, a, i
    input = document.getElementById("sideBarInput")
    // @ts-ignore
    filter = input.value.toUpperCase()
    const div = document.getElementById("sidebar")
    // @ts-ignore
    a = div.getElementsByTagName("a")
    for (i = 0; i < a.length; i++) {
        const txtValue = a[i].textContent || a[i].innerText
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
            a[i].style.display = "block"
        } else {
            a[i].style.display = "none"
        }
    }
}
searchItem.addEventListener("search", function () {
    // @ts-ignore
    const a = div.getElementsByTagName("a")
    // @ts-ignore
    for (i = 0; i < a.length; i++) {
        // @ts-ignore
        a[i].style.display = "block"
    }
})

///////////////// BUTTONS ///////////////////////

// FOLDERS
const itemBarFile = document.createElement("div")
const itemBarAdjust = document.createElement("div")
const itemBarProcess = document.createElement("div")
const itemBarView = document.createElement("div")
// const itemBarData = document.createElement("div")
const itemBarEdit = document.createElement("div")

////////// FILE /////////////

/// Accordion Open/Close Button
const accButtonFile = document.createElement("button")
accButtonFile.className = "jv-button jv-block jv-left-align"
accButtonFile.name = ' <img width="25" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/document-outline.svg"></img>'
accButtonFile.innerHTML = accButtonFile.name + ' <img width="15" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down.svg"></img>'
accButtonFile.onclick = function () {
    myAccFunc(accFile.id)
}

/// Container for Accordion Menu Items
const accFile = document.createElement("div")
accFile.id = "AccFile"
accFile.className = "jv-hide jv-card"
accFile.style.boxShadow = "none"
accFile.style.margin = "0px 0px 5px 15px"

/// FILE MENU ITEMS

const accItemFileLoadImage = document.createElement("a")
accItemFileLoadImage.href = "#"
accItemFileLoadImage.className = "jv-bar-item jv-button"
accItemFileLoadImage.innerHTML = " "
accItemFileLoadImage.innerText += "Load Image"
accItemFileLoadImage.onclick = function () {
    createCellWithCode("image_data[JIVECore.Files.loadImage!(image_data, image_keys)]")
}
const accItemFileImportSequence = document.createElement("a")
accItemFileImportSequence.href = "#"
accItemFileImportSequence.className = "jv-bar-item jv-button"
accItemFileImportSequence.innerHTML = " "
accItemFileImportSequence.innerText += "Import Sequence"
accItemFileImportSequence.onclick = function () {
    createCellWithCode("Images.mosaicview(image_data[JIVECore.Files.loadImage!(image_data, image_keys)]; fillvalue=0.5, npad=2, ncol=7, rowmajor=true)")
}
const accItemFileImportVideo = document.createElement("a")
accItemFileImportVideo.href = "#"
accItemFileImportVideo.className = "jv-bar-item jv-button"
accItemFileImportVideo.innerHTML = " "
accItemFileImportVideo.innerText += "Import Video"
accItemFileImportVideo.onclick = function () {
    createCellWithCode("JIVECore.Visualize.gif(image_data[JIVECore.Files.loadImage!(image_data, image_keys)])")
}
const accItemFileSaveImage = document.createElement("a")
accItemFileSaveImage.href = "#"
accItemFileSaveImage.className = "jv-bar-item jv-button"
accItemFileSaveImage.innerHTML = " "
accItemFileSaveImage.innerText += "Save Image"
accItemFileSaveImage.onclick = async function () {
    const x = getVarName("save")
    createMDCellWithUI("Save Image", `Select image to save: $(@bind ${x} PlutoUI.confirm(PlutoUI.Select(image_keys, default=image_keys[end])))`)
    await resolveAfterTimeout(timeoutValue)
    createCellWithCode(`JIVECore.Files.saveImage(image_data[${x}])`)
}
const accItemFileReset = document.createElement("a")
accItemFileReset.href = "#"
accItemFileReset.className = "jv-bar-item jv-button"
accItemFileReset.innerHTML = " "
accItemFileReset.innerText += "Reset Images"
accItemFileReset.onclick = async function () {
    createMDCellWithUI("", '!!! warning "warning"\n\t All images stored in `image_data` were deleted!')
    await resolveAfterTimeout(timeoutValue)
    createCellWithCode("empty!(image_data); empty!(image_keys);")
}

accFile.appendChild(accItemFileLoadImage)
accFile.appendChild(accItemFileImportSequence)
accFile.appendChild(accItemFileImportVideo)
accFile.appendChild(accItemFileSaveImage)
accFile.appendChild(accItemFileReset)
itemBarFile.appendChild(accButtonFile)
itemBarFile.appendChild(accFile)

////////// ADJUST /////////////

/// Accordion Open/Close Button
const accButtonAdjust = document.createElement("button")
accButtonAdjust.className = "jv-button jv-block jv-left-align"
accButtonAdjust.name = ' <img width="25" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/contrast-outline.svg"></img>'
accButtonAdjust.innerHTML =
    accButtonAdjust.name + ' <img width="15" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down.svg"></img>'
accButtonAdjust.onclick = function () {
    myAccFunc(accAdjust.id)
}

/// Container for Accordion Menu Items
const accAdjust = document.createElement("div")
accAdjust.id = "AccAdjust"
accAdjust.className = "jv-hide jv-card"
accAdjust.style.boxShadow = "none"
accAdjust.style.margin = "0px 0px 5px 15px"

/// ADJUST MENU ITEMS

const accItemAdjustContrast = document.createElement("a")
accItemAdjustContrast.href = "#"
accItemAdjustContrast.className = "jv-bar-item jv-button"
accItemAdjustContrast.innerHTML = " "
accItemAdjustContrast.innerText += "Contrast"
accItemAdjustContrast.onclick = async function () {
    const x = getVarName("autocontrast")
    createMDCellWithUI("Autocontrast", `Select input image: $(@bind ${x} PlutoUI.Select(image_keys, default=image_keys[end]))`)
    await resolveAfterTimeout(timeoutValue)
    createCellWithCode(`JIVECore.Process.autoContrast(image_data[${x}])`)
}
const accItemAdjustColor = document.createElement("a")
accItemAdjustColor.href = "#"
accItemAdjustColor.className = "jv-bar-item jv-button"
accItemAdjustColor.innerHTML = " "
accItemAdjustColor.innerText += "Color"

accAdjust.appendChild(accItemAdjustContrast)
accAdjust.appendChild(accItemAdjustColor)
itemBarAdjust.appendChild(accButtonAdjust)
itemBarAdjust.appendChild(accAdjust)

////////// EDIT /////////////

/// Accordion Open/Close Button
const accButtonEdit = document.createElement("button")
accButtonEdit.className = "jv-button jv-block jv-left-align"
accButtonEdit.name = ' <img width="25" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/create-outline.svg"></img>'
accButtonEdit.innerHTML = accButtonEdit.name + ' <img width="15" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down.svg"></img>'
accButtonEdit.onclick = function () {
    myAccFunc(accEdit.id)
}

/// Container for Accordion Menu Items
const accEdit = document.createElement("div")
accEdit.id = "AccEdit"
accEdit.className = "jv-hide jv-card"
accEdit.style.boxShadow = "none"
accEdit.style.margin = "0px 0px 5px 15px"

/// EDIT MENU ITEMS
const accItemEditAnnotate = document.createElement("a")
accItemEditAnnotate.href = "#"
accItemEditAnnotate.className = "jv-bar-item jv-button"
accItemEditAnnotate.innerHTML = " "
accItemEditAnnotate.innerText += "Annotate"
accItemEditAnnotate.onclick = async function () {
    const img = getVarName("annotate_image")
    const ops = getVarName("annotate_operation")
    const coords = getVarName("annotate_coords")
    const apply = getVarName("annotate_apply")
    const plot = getVarName("annotate_plot")
    const shps = getVarName("annotate_shapes")
    createCellWithCode(`${shps} = Dict()
md"""
##### Annotate
---

1. Choose image: $(@bind ${img} Select(image_keys, default=image_keys[end]) ) 
1. Select Area 
1. Choose operation: $(@bind ${ops} confirm(Select([1 => "crop", 2 => "fill", 3 => "plot"])) )

---

$(
@bind ${coords} let
    ${plot}  = create_plotly_visualizer(image_data[${img}], "heatmap")
    create_plotly_listener(${plot})
    ${plot} 
end
)
---


Apply last operation to the selected images (press Ctrl to select multiple items):

$(@bind ${apply} confirm(MultiSelect(image_keys)) )"
"""
`)
    await resolveAfterTimeout(timeoutValue)
    createCellWithCode(`record_plotly_shapes(${coords}["shape"])(${shps},${coords});`)
}

//// add items to menu
accEdit.appendChild(accItemEditAnnotate)
// accEdit.appendChild(accItemEdit)
itemBarEdit.appendChild(accButtonEdit)
itemBarEdit.appendChild(accEdit)

////////// PROCESS /////////////

/// Accordion Open/Close Button
const accButtonProcess = document.createElement("button")
accButtonProcess.className = "jv-button jv-block jv-left-align"
accButtonProcess.name = ' <img width="25" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/cog-outline.svg"></img>'
accButtonProcess.innerHTML =
    accButtonProcess.name + ' <img width="15" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down.svg"></img>'
accButtonProcess.onclick = function () {
    myAccFunc(accProcess.id)
}

/// Container for Accordion Menu Items
const accProcess = document.createElement("div")
accProcess.id = "AccProcess"
accProcess.className = "jv-hide jv-card"
accProcess.style.boxShadow = "none"
accProcess.style.margin = "0px 0px 5px 15px"

//// add items to menu
// accEdit.appendChild(accItemEditAnnotate)
// accEdit.appendChild(accItemEdit)
itemBarProcess.appendChild(accButtonProcess)
itemBarProcess.appendChild(accProcess)

////////// VIEW /////////////

/// Accordion Open/Close Button
const accButtonView = document.createElement("button")
accButtonView.className = "jv-button jv-block jv-left-align"
accButtonView.name = ' <img width="25" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/tv-outline.svg"></img>'
accButtonView.innerHTML = accButtonView.name + ' <img width="15" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down.svg"></img>'
accButtonView.onclick = function () {
    myAccFunc(accView.id)
}

/// Container for Accordion Menu Items
const accView = document.createElement("div")
accView.id = "AccView"
accView.className = "jv-hide jv-card"
accView.style.boxShadow = "none"
accView.style.margin = "0px 0px 5px 15px"

//// add items to menu
// accEdit.appendChild(accItemEditAnnotate)
// accEdit.appendChild(accItemEdit)
itemBarView.appendChild(accButtonView)
itemBarView.appendChild(accView)

//////////////// Put menu together ///////////////////

sideBar.appendChild(closeBtn)
sideBar.appendChild(titleDiv)
sideBar.appendChild(searchItem)
sideBar.appendChild(itemBarFile)
sideBar.appendChild(itemBarEdit)
sideBar.appendChild(itemBarAdjust)
sideBar.appendChild(itemBarProcess)
sideBar.appendChild(itemBarView)

////////////////
// FUNCTIONS //
///////////////

function w3_open() {
    // @ts-ignore
    frameDiv.style = "margin-left: var(--sidebar-width) !important;"
    // @ts-ignore
    sideBar.style = "width: var(--sidebar-width);"
    sideBar.style.display = "block"
    openButton.style.visibility = "hidden"
}

function w3_close() {
    // @ts-ignore
    frameDiv.style = "margin-left: 0% !important;"
    // @ts-ignore
    sideBar.style = "width: 0% !important;"
    sideBar.style.display = "none"
    openButton.style.visibility = "visible"
}

function myAccFunc(idString) {
    var x = document.getElementById(idString)
    // @ts-ignore
    if (x.className.indexOf("jv-show") == -1) {
        // @ts-ignore
        x.className += " jv-show"
        x.previousElementSibling.innerHTML =
            x.previousElementSibling.name + ' <img width="15" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-up.svg"></img>'
    } else {
        // @ts-ignore
        x.className = x.className.replace(" jv-show", "")
        x.previousElementSibling.innerHTML =
            x.previousElementSibling.name + ' <img width="15" src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down.svg"></img>'
    }
}
// wait
function resolveAfterTimeout(t) {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve("resolved")
        }, t)
    })
}
// Obtain pluto-cell HTML element
function getPlutoCell(el) {
    try {
        if (el.tagName !== "PLUTO-CELL") {
            return getPlutoCell(el.parentElement)
        }
        return el
    } catch (e) {}
}
// Create variable name
function getVarName(prefix) {
    return prefix + Date.now()
}
// Create div with code to insert in a cell
function insertCode(text) {
    const divStart = document.createElement("div")
    divStart.classList.add("cm-line")
    const spanStart = document.createElement("span")
    spanStart.classList.add("ͼx")
    spanStart.innerText = text
    divStart.appendChild(spanStart)
    return divStart
}
//   Create a new cell with code
async function createCellWithCode(textCode) {
    const currentCell = getPlutoCell(getSelection().anchorNode)
    const cellCode = currentCell.querySelector("div[role='textbox'].cm-content")
    const beginDiv = insertCode(textCode)
    cellCode.firstElementChild.before(beginDiv)
    currentCell.querySelector("button.foldcode").click()
    currentCell.querySelector("button.runcell").click()
    currentCell.querySelector("button.add_cell.after").click()
}
// Create div with Markdown code to insert in a cell
function insertMD(title, text) {
    const divStart = document.createElement("div")
    divStart.classList.add("cm-line")
    const spanStart = document.createElement("span")
    spanStart.classList.add("ͼx")
    startText = 'md"""'
    titleText = "##### " + title
    endText = '"""'
    finalText = startText + "\n" + titleText + "\n" + text + "\n" + endText
    spanStart.innerText = finalText
    divStart.appendChild(spanStart)
    return divStart
}
//   Create a new MD cell with PlutoUI code
async function createMDCellWithUI(title, textCode) {
    const currentCell = getPlutoCell(getSelection().anchorNode)
    const cellCode = currentCell.querySelector("div[role='textbox'].cm-content")
    const beginDiv = insertMD(title, textCode)
    cellCode.firstElementChild.before(beginDiv)
    currentCell.querySelector("button.foldcode").click()
    currentCell.querySelector("button.runcell").click()
    currentCell.querySelector("button.add_cell.after").click()
}
