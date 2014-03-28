# encoding: utf-8

class CsvFileUploader < CarrierWave::Uploader::Base
  def extension_white_list
    %w(csv)
  end
end
