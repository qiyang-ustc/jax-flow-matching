# Import Hosts related variables (image, data, etc.)
include ./config/hosts/${HOSTNAME}.env

# Import job related variables (script, args, etc.)
include ./config/params/basic.env

init: always
	mkdir -p ${DATA_DIR}
	singularity exec ${SIF_IMAGE} pip list

jupyter: always
	${SLRUM_PREFIX} jupyter notebook --no-browser --port=6006 --ip='*' --NotebookApp.token='' --NotebookApp.password=''

clear_cp: always
	rm -rf ${DATA_DIR}/*

train: always
	${SLRUM_PREFIX} singularity exec --nv ${DATA_BINDS} ${SIF_IMAGE} python3 ${SCRIPT} ${TRAIN_ARGS} --folder ${DATA_DIR}

inference: always
	
show_loss: always
	cat ${DATA_DIR}/loss.txt

test_env: always
	${SLRUM_PREFIX} singularity exec --nv ${SIF_IMAGE} nvidia-smi

always:
	# Do nothing