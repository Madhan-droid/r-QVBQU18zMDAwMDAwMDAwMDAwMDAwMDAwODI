import fs from "fs";
import {ProductStack} from "@cny-cdk-stack/products";
import {DiscoveryServiceInternal} from "@cny-cdk-stack/discovery-services";
import {PrerequisiteDeployment} from "@cny-cdk-stack/prerequisite-deployment";
import {TYPES, deployStacks} from "@cny-common/aws.cdk.ts";
import {CONSTANTS} from "./app-constants";
const inputData: TYPES.InputData = JSON.parse(fs.readFileSync("./inputs.json", "utf-8"));
const {stage} = inputData;
const {productShortName, orgShortName, stackName}: TYPES.AppConstants = CONSTANTS;
const dependencyStackInfo: TYPES.DependencyStackInfo[] = [
     {class: PrerequisiteDeployment, stackName: "prerequisite-deployment-stack", isGlobal: true},
     {class: DiscoveryServiceInternal, stackName: "discovery-service-cdk-stack", isRoot: true}
];

(async () => {
     try {
          await deployStacks(dependencyStackInfo, ProductStack, {productShortName, orgShortName, stackName, stage});
     } catch (error) {
          console.error("Error deploying stacks:", error);
          process.exit(1);
     }
})();
