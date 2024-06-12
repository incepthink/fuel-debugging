import { Contract, Provider, Wallet } from "fuels";

const provider = await Provider.create(
  "https://testnet.fuel.network/v1/graphql"
);
const wallet = Wallet.fromPrivateKey(
  "0xb2a321f23cf389da7a6d99cf6cd3d8d8658fe83f74baa888021c839fac859def",
  provider
);

const getFuelABI = () => {
  return require("../contract/out/debug/invalid-decode-value-abi.json");
};

const abi = getFuelABI();
const contract = new Contract(
  "0x06e55949f751b2ecb5f90ad9a94fabd7eb8c6b5353f6c673798a3e87a90b7fbd",
  abi,
  wallet
);

const receipt = contract.functions.mint(
  "0x87b95295483240643f46de64f0d45415bbde65e3bea765823f20515c56673b2e",
  "metadata-abcd"
).call();

console.log(receipt);

/**
 * I tried following the bits format as well when passing address as seen on the sway playground:
 * {
 *   "Address": {
 *     "bits": "0x87b95295483240643f46de64f0d45415bbde65e3bea765823f20515c56673b2e"
 *   }
 * }
 */
