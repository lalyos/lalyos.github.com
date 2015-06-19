#bundle exec rake generate

# build the docker image locaaly:
# docker build -t octopress .

docker run -v $PWD:/data -w /data --entrypoint=bash octopress:latest -c 'rake generate'
tar -czvf public.tgz -C public/ .
rm -rf public
git clone git@github.com:lalyos/lalyos.github.com.git public
tar -xzvf public.tgz -C public

