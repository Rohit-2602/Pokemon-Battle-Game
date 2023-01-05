import * as IPFS from 'ipfs-core'
import fs from 'fs'
import path from "path"

async function main() {
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

function updateNameToIPFSFile(pokemonName, url) {
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