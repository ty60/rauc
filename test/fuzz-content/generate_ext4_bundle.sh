#!/bin/bash

set -eux


rauc_base=/home/ty/work/rauc
rauc=${rauc_base}/rauc
img_name=fuzzfs.ext4
tmp_dir=tmp
raucb_name=fuzz_ext4.raucb


if [[ ! -f ${img_name} ]]; then
    echo "generate ${img_name}"
    exit 1
fi


if [[ -d ${tmp_dir} ]]; then
    rm -rf ${tmp_dir}
fi

if [[ -f ${raucb_name} ]]; then
    rm ${raucb_name}
fi

mkdir ${tmp_dir}
cp $img_name ${tmp_dir}

cat > ${tmp_dir}/manifest.raucm << EOF
[update]
compatible=rauc-fuzz
version=hoge
[bundle]
format=plain
[image.rootfs]
filename=${img_name}
EOF

${rauc} bundle \
    --cert demo.cert.pem \
    --key demo.key.pem \
    ${tmp_dir} \
    ${raucb_name}

rm -rf ${tmp_dir}

${rauc} info --no-verify ${raucb_name}
