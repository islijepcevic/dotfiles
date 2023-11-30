NAME=torch
conda create --name $NAME python=3.10
conda install -y pytorch::pytorch torchvision torchaudio -c pytorch
# anaconda
conda install -y -c anaconda numpy scipy jupyter scikit-learn pandas \
  more-itertools seaborn flake8

# conda-forge
conda install -y -c conda-forge matplotlib lightning black

# GNNs
pip install torch_geometric  # --no-input
# pip install pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-2.1.0+cpu.html


# GEO-specific
conda install -y -c conda-forge pyproj shapely geopy mercantile
