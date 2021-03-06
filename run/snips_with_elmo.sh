#!/bin/bash

source ./path.sh

task_slot_filling=slot_tagger_with_focus #slot_tagger, slot_tagger_with_crf, slot_tagger_with_focus
task_intent_detection=hiddenAttention # none, hiddenAttention, hiddenCNN, maxPooling, 2tails
balance_weight=0.5

elmo_json_file="https://allennlp.s3.amazonaws.com/models/elmo/2x4096_512_2048cnn_2xhighway/elmo_2x4096_512_2048cnn_2xhighway_options.json"
elmo_weight_file="https://allennlp.s3.amazonaws.com/models/elmo/2x4096_512_2048cnn_2xhighway/elmo_2x4096_512_2048cnn_2xhighway_weights.hdf5"
#elmo_json_file=../data/pretrained_models/language_model/ELMo_allenai/models/elmo/2x4096_512_2048cnn_2xhighway/elmo_2x4096_512_2048cnn_2xhighway_options.json
#elmo_weight_file=../data/pretrained_models/language_model/ELMo_allenai/models/elmo/2x4096_512_2048cnn_2xhighway/elmo_2x4096_512_2048cnn_2xhighway_weights.hdf5
word_lowercase=false

dataroot=data/snips
dataset=snips

#word_embedding_size=1024
lstm_hidden_size=200
lstm_layers=2
slot_tag_embedding_size=100  ## for slot_tagger_with_focus
batch_size=20

optimizer=adam
learning_rate=0.001
max_norm_of_gradient_clip=5
dropout_rate=0.5

max_epoch=20

device=0
# device=0 means auto-choosing a GPU
# Set deviceId=-1 if you are going to use cpu for training.
experiment_output_path=exp

source ./utils/parse_options.sh

if [[ $word_lowercase != true && $word_lowercase != True ]]; then
  unset word_lowercase
fi

python scripts/slot_tagging_and_intent_detection_with_elmo.py --task_st $task_slot_filling --task_sc $task_intent_detection --dataset $dataset --dataroot $dataroot --bidirectional --lr $learning_rate --dropout $dropout_rate --batchSize $batch_size --optim $optimizer --max_norm $max_norm_of_gradient_clip --experiment $experiment_output_path --deviceId $device --max_epoch $max_epoch --hidden_size $lstm_hidden_size --num_layers ${lstm_layers} --tag_emb_size $slot_tag_embedding_size --st_weight ${balance_weight} ${word_lowercase:+--word_lowercase} --elmo_json ${elmo_json_file} --elmo_weight ${elmo_weight_file}
