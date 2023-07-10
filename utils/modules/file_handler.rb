require 'mime/types'

module FileHandler
  DEFAULT_DOWNLOADS_FOLDER = 'downloads'.freeze

  def destination_folder(create_if_absent: true)
    folder_path = "downloads/#{Date.today.to_s}"

    if create_if_absent
      FileUtils.mkdir_p(folder_path) unless File.directory?(folder_path)
    else
      folder_path = DEFAULT_DOWNLOADS_FOLDER
    end

    folder_path
  end

  def build_filename(response:, url:)
    draft_filename = File.basename(url)

    if File.extname(draft_filename).empty?
      extension = MIME::Types[response.headers['Content-Type']].first.extensions.first
      filename = "#{filename}.#{extension}"
    else
      filename = draft_filename
    end

    "#{Time.now.strftime('%s')}#{filename}"
  end

  def write_file_to_folder(file_data:, filename:)
    file_path = File.join(destination_folder, filename)

    File.open(file_path, 'wb') do |file|
      file.write(file_data)
    end
  end
end
