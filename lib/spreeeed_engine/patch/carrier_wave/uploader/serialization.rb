module SpreeeedEngine
  module Patch
    module CarrierWave
      module Uploader
        module Serialization
          def serializable_hash(options = nil)
            {'url' => url}.merge Hash[versions.map { |name, version| [name, trace_versions(version)] }]
          end


          def trace_versions(version)
            res = { 'url' => version.url }
            version.versions.each { |version_name, nested_version|
              res.merge!(Hash[version_name, trace_versions(nested_version)])
            }
            res
          end
        end
      end
    end
  end
end