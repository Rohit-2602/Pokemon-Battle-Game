async function main() {
  const Pokemon = await ethers.getContractFactory("Pokemon");
  const pokemon = await Pokemon.deploy();

  console.log("Deploying Pokemon...")
  await pokemon.deployed();

  console.log(
    `Pokemon Deployed Address: ${pokemon.address}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
