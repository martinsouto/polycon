module ProfessionalsHelper

    def professionals_names
        arr1 = ["-"]
        arr2 = Professional.all.map { |each| each.name }
        arr1.concat arr2
    end
end
