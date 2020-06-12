# Instructions

## Binary Installation

Install the latest Helm 3 binary from the [Helm Release on GitHub](https://github.com/helm/helm/releases/).

Validate install with the following command:

```bash
helm version
```

Returns:

```bash
version.BuildInfo{Version:"v3.2.3", GitCommit:"8f832046e258e2cb800894579b1b3b50c2d83492", GitTreeState:"clean", GoVersion:"go1.13.12"}
```

## Add Stable Repository

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
```
