# docker-terraform
Run Terraform Inside Docker

## Build
```
./build
```

## Aliases
```
alias tf='docker run -v `pwd`:/docker -w /docker --rm -it terraform terraform'
```
```
alias tfgraph='docker run -v `pwd`:/docker -w /docker --rm -it terraform terraform graph | dot -Tpng > graph.png'
```

## Run
```
tf version
```
```
tfgraph
```
