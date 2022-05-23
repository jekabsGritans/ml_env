FROM jupyter/minimal-notebook:latest

ARG conda_env=ml_env
ARG py_ver=3.8

RUN mamba create --quiet --yes -p "${CONDA_DIR}/envs/${conda_env}" python=${py_ver} ipython ipykernel && \
    mamba clean --all -f -y

RUN mamba install -c conda-forge jupyterlab_vim jupyterlab-git ipywidgets

RUN conda install -n ${conda_env} --yes pytorch torchvision torchaudio cudatoolkit=11.3 scikit-learn transformers -c pytorch -c conda-forge -c huggingface

# create Python kernel and link it to jupyter
RUN "${CONDA_DIR}/envs/${conda_env}/bin/python" -m ipykernel install --user --name="${conda_env}" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN "${CONDA_DIR}/envs/${conda_env}/bin/pip" install --quiet --no-cache-dir lckr-jupyterlab-variableinspector matplotlib pandas

RUN echo "conda activate ${conda_env}" >> "${HOME}/.bashrc"
