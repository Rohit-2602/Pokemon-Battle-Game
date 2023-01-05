// npx hardhat run scripts/deployPokemon.js --network mumbai
async function main() {
  const Pokemon = await ethers.getContractFactory("Pokemon");
  const pokemon = await Pokemon.deploy();

  console.log("Deploying Pokemon...")
  await pokemon.deployed();

  console.log(`Pokemon Deployed Address: ${pokemon.address}`);
  saveFrontendFiles(pokemon)
}

function saveFrontendFiles(pokemon) {
  const path = require("path");
  const fs = require("fs");

  const contractsDir = path.join(__dirname, "../", "frontend", "src", "contracts");

  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir);
  }

  var addressData = JSON.parse(fs.readFileSync(path.join(contractsDir, "contract-address.json")));
  addressData["Pokemon"] = pokemon.address;

  fs.writeFileSync(
    path.join(contractsDir, "contract-address.json"),
    JSON.stringify(addressData)
  );

  const pokemonContract = artifacts.readArtifactSync("Pokemon");

  fs.writeFileSync(
    path.join(contractsDir, "PokemonABI.json"),
    JSON.stringify({ abi: pokemonContract.abi }, null, 2)
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
