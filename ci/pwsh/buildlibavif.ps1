#! /usr/bin/pwsh

# Clone
git clone https://github.com/AOMediaCodec/libavif.git
cd libavif
git checkout $(git tag | select -last 1)

# vcvars on windows
if ($IsWindows) {
    & "$env:BUILD_REPOSITORY_LOCALPATH/ci/pwsh/vcvars.ps1"
}

# Get meson
python -m pip install meson
Set-Alias -Name meson -Value python -m meson

# Get ninja
if ($IsWindows) {
    choco install ninja
} elseif ($IsMacOS) {
    brew install ninja
} else {
    sudo apt install ninja
}

# Build dav1d
cd ext

if ($IsWindows) {
    
} else {
    bash dav1d.cmd
}

# Build libavif 

mkdir ../build
cd ../build

cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DAVIF_CODEC_DAV1D=ON -DAVIF_LOCAL_DAV1D=ON ..
ninja
$env:DESTDIR = "installed/"
ninja install