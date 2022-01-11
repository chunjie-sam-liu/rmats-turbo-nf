# rmats-turbo-nf

rmats-turbo nextflow

## Pull docker image from docker hub as singularity sif files
```
cd ${HOME}/sif
singularity pull docker://chunjiesamliu/rmats-turbo-nf:latest
```

## Configure customised Nextflow config file
```
# ccle test data, test-ccle.config
params {
  projectName = "ccle_test"
  reads = "test-ccle-10.tsv"
  singleEnd = false
  readLength = 101
  ngcFile = false

  starIndex = "path/to/star/index"
  gtf = "path/to/gtf"

  outdir = "path/to/output"
  publishDir = "path/to/publishDir"
  traceDir = "path/to/traceDir"
}

workDir = "/tmp/rmats-turbo-nf"

executor {
  name = "slurm"
  queueSize = 10
}

tower {
  enabled = true
  endpoint = "-"
}
```

Nextflow run:
```
nextflow run path/to/rmats-turbo-nf/main.nf \
  -config test-ccle.config \
  -profile base,singularity \
  -resume
```