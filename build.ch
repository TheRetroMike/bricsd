export PATH=$PATH:/usr/local/go/bin
go install . ./cmd/...
#go install -ldflags "-X main.version=1.0.0" -buildvcs=false . ./cmd/...