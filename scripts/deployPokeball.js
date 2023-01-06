async function main() {
    const Pokeball = await ethers.getContractFactory("Pokeball");
    const pokeball = await Pokeball.deploy();

    console.log("Deploying Pokeball...");
    await pokeball.deployed();

    console.log("Pokeball Contract Address: ", pokeball.address)
    const pokeBallURI = await pokeball.updateTokenUri(1, "https://gateway.pinata.cloud/ipfs/QmSJ3ggrzQmWv8k8FwDb7aUgg36hcFtnDEjJNJeqthxbgb/PokeBall.json")
    const greatBallURI = await pokeball.updateTokenUri(2, "https://gateway.pinata.cloud/ipfs/QmSJ3ggrzQmWv8k8FwDb7aUgg36hcFtnDEjJNJeqthxbgb/GreatBall.json")
    const ultraBallURI = await pokeball.updateTokenUri(3, "https://gateway.pinata.cloud/ipfs/QmSJ3ggrzQmWv8k8FwDb7aUgg36hcFtnDEjJNJeqthxbgb/UltraBall.json")
    const masterBallURI = await pokeball.updateTokenUri(4, "https://gateway.pinata.cloud/ipfs/QmSJ3ggrzQmWv8k8FwDb7aUgg36hcFtnDEjJNJeqthxbgb/MasterBall.json")

    console.log(pokeBallURI.hash)
    console.log(greatBallURI.hash)
    console.log(ultraBallURI.hash)
    console.log(masterBallURI.hash)

    const pokeballPrice = await pokeball.updateTokenPrice(1, "5000000000000000")
    const greatballPrice = await pokeball.updateTokenPrice(2, "10000000000000000")
    const ultraballPrice = await pokeball.updateTokenPrice(3, "15000000000000000")
    const masterballPrice = await pokeball.updateTokenPrice(4, "20000000000000000")

    console.log(pokeballPrice.hash)
    console.log(greatballPrice.hash)
    console.log(ultraballPrice.hash)
    console.log(masterballPrice.hash)

    saveFrontendFiles(pokeball)
}

function saveFrontendFiles(pokeball) {
    const path = require('path')
    const fs = require('fs')

    const contractsDir = path.join(__dirname, "../", "frontend", "src", "contracts")

    if (!fs.existsSync(contractsDir)) {
        fs.mkdirSync(contractsDir);
    }

    var addressData = JSON.parse(fs.readFileSync(path.join(contractsDir, "contract-address.json")))
    addressData["Pokeball"] = pokeball.address

    fs.writeFileSync(
        path.join(contractsDir, "contract-address.json"),
        JSON.stringify(addressData)
    )

    const pokeballContract = artifacts.readArtifactSync("Pokeball")
    fs.writeFileSync(
        path.join(contractsDir, "PokeballABI.json"),
        JSON.stringify({ abi: pokeballContract.abi }, null, 2)
    );
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});