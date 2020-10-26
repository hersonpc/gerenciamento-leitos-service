# Gerenciamento Tático Hospitalar


## Manipulando a imagem no Docker

Para construção da imagem no Docker, abaixo segue demostrado os modelos de comandos para este fim. Primeirante constroi-se a imagem, depois se já houver uma imagem anterior em execução, finaliza-se, e então podemos instanciar a imagem criada, criando efetivamente um container que execute o conteudo preparado na imagem.

```
# Construindo a imagem no docker
docker build -f Dockerfile -t hersonpc/gerenciamento-leitos:teste .

docker build -f Dockerfile -t hersonpc/gerenciamento-leitos:1.2.1 .
docker push hersonpc/gerenciamento-leitos:1.2.1

# Parando e atualizando o servido no Swarm
docker service rm compliance
docker service create --name compliance --replicas 2 --publish 3000:3000 hersonpc/gerenciamento-leitos:1.2.1



# Parando todas as instancias do docker
docker rm --force $(docker container ls -a -q)
```

## Inicializar o sistema via Docker

```
docker run -it -d --name gth -p 3000:3000 hersonpc/gerenciamento-leitos
```

Eventualmente, caso haja a necessidade de se verificar o interior do container em execução, pode-se utilizar o seguinte comando

```
docker exec -it gth bash
```

## Criar conainter do PAServer

Para compilação na plataforma Linux através do código do RAD Studio, é necessário uma instancia do PAServer, que pode ser obtida pelo código abaixo.

```
# Para Delphi Rio 10.3
docker run -it -d --rm --name paserver -p 64211:64211 hersonpc/paserver:10.3

# Para analisar o container em execução
docker exec -it paserver bash
```