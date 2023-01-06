import * as IPFS from 'ipfs-core'
import fs from 'fs'
import path from "path"

async function main() {
    // uploadPokeballImages();
    uploadPokeballMetadata();
    // uploadPokemonImages();
}

async function uploadPokeballImages() {
    const directory = "D:\\Github Personal\\Pokemon Battle Game\\metadata\\Pokeball Images"
    const files = fs.readdirSync(directory)

    const ipfs = await IPFS.create()
    const ipfsBaseUrl = "https://ipfs.io/ipfs/"

    for(let file of files) {
        const buffer = fs.readFileSync(`${directory}/${file}`)
        const result = await ipfs.add(buffer)

        const ballName = file.split(".")[0]
        updatePokeBallMetadata(ballName, ipfsBaseUrl + result.path)
    }
}

function updatePokeBallMetadata(pokeballName, url) {
    const pokeballMetadataDir = "D:\\Github Personal\\Pokemon Battle Game\\metadata\\PokeballMetadata\\";
    if (!fs.existsSync(pokeballMetadataDir)) {
        fs.mkdirSync(pokeballMetadataDir);
    }

    var data = fs.readFileSync(path.join(pokeballMetadataDir, `${pokeballName}.json`))
    var jsonData = JSON.parse(data)
    jsonData["image"] = url
    fs.writeFileSync(path.join(pokeballMetadataDir, `${pokeballName}.json`), JSON.stringify(jsonData))
}

async function uploadPokeballMetadata() {
    const pokeballMetadataDir = "D:\\Github Personal\\Pokemon Battle Game\\metadata\\PokeballMetadata\\"
    const files = fs.readdirSync(pokeballMetadataDir)

    const ipfs = await IPFS.create()
    const ipfsBaseUrl = "https://ipfs.io/ipfs/"

    for (let file of files) {
        const buffer = fs.readFileSync(`${pokeballMetadataDir}/${file}`)
        const result = await ipfs.add(buffer)
        console.log(ipfsBaseUrl + result.path)
        // const splitName = file.split(".")
        // console.log(splitName[0].substring(3))
        // updateNameToIPFSFile(splitName[0].substring(3), ipfsBaseUrl + result.path)
    }
}

async function uploadPokemonImages() {
    const directory = "D:\\Github Personal\\Pokemon Battle Game\\metadata\\Pokemon Images"
    const files = fs.readdirSync(directory)

    const ipfs = await IPFS.create()
    const ipfsBaseUrl = "https://ipfs.io/ipfs/"

    for (let file of files) {
        const buffer = fs.readFileSync(`${directory}/${file}`)
        const result = await ipfs.add(buffer)

        const splitName = file.split(".")
        console.log(splitName[0].substring(3))
        updateNameToIPFSFile(splitName[0].substring(3), ipfsBaseUrl + result.path)
    }
}

function updatePokemonNameToIPFSFile(pokemonName, url) {
    const utilsDir = "D:\\Github Personal\\Pokemon Battle Game\\metadata\\";

    if (!fs.existsSync(utilsDir)) {
        fs.mkdirSync(utilsDir);
    }

    var data = fs.readFileSync(path.join(utilsDir, "PokemonNameToIPFSImage.json"));

    var jsonData = JSON.parse(data)
    jsonData[pokemonName] = url

    const updatedData = JSON.stringify(jsonData);
    fs.writeFileSync(path.join(utilsDir, "PokemonNameToIPFSImage.json"), updatedData);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});