import k8s, { KubernetesObject } from "@kubernetes/client-node";

interface VolumeSnapshot extends KubernetesObject {
  spec: {
    volumeSnapshotClassName: string,
    source: {
      persistentVolumeClaimName: string
    }
  }
}

export const takeSnapshots = async (k8sApi: k8s.KubernetesObjectApi, sts: string, pvcList: string) => {
  const timestamp = new Date().getTime();
  await Promise.all(pvcList
  .split(',')
  .map(async pvc => takeSnapshot(k8sApi, sts, pvc, timestamp)))
}

const takeSnapshot = async (k8sApi: k8s.KubernetesObjectApi, sts: string, pvcName: string, timestamp: number) => {  
  var snapshotName = `${pvcName}-backup-${timestamp}`
  console.log(`Taking snapshot of pvc ${pvcName} - ${snapshotName}`);
  const snapshotYaml: VolumeSnapshot = {
    apiVersion: "snapshot.storage.k8s.io/v1",
    kind: "VolumeSnapshot",
    metadata: {
      name: snapshotName,
      labels: {
        "statefulset": sts
      }
    },
    spec: {
      volumeSnapshotClassName: "csi-aws-vsc",
      source: {
        persistentVolumeClaimName: pvcName,
      },
    },

  };
  await k8sApi.create(snapshotYaml)
  console.log(`Snapshot ${snapshotName} backup finished`)
};
