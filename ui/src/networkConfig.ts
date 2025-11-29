import { getFullnodeUrl } from "@mysten/sui/client";
import { createNetworkConfig } from "@mysten/dapp-kit";

/**
 * Package ID retrieved from transaction summary, after runnning `sui client publish`
 *
 * Example:
 * ```bash
 *  Published Objects:
 * ┌──
 * │ PackageID: 0xa62c3b4c74840fbc3512cd67fc2446f67201e520e49e73474f28d520054f49a2
 * │ Version: 1
 * │ Digest: bn8Vs7TgMzhyPN4GtjDdjTfufX67dErp4926bQeCSFr
 * │ Modules: arena, hero, marketplace
 * └──
 */
const PACKAGE_ID = "0xa62c3b4c74840fbc3512cd67fc2446f67201e520e49e73474f28d520054f49a2";

const { networkConfig, useNetworkVariable, useNetworkVariables } =
  createNetworkConfig({
    devnet: {
      url: getFullnodeUrl("devnet"),
      variables: { packageId: PACKAGE_ID },
    },
    testnet: {
      url: getFullnodeUrl("testnet"),
      variables: { packageId: PACKAGE_ID },
    },
    mainnet: {
      url: getFullnodeUrl("mainnet"),
      variables: { packageId: PACKAGE_ID },
    },
  });

export { useNetworkVariable, useNetworkVariables, networkConfig };
