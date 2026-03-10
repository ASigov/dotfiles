return {
    settings = {
        ['csharp|background_analysis'] = {
            dotnet_analyzer_diagnostics_scope = 'openfiles',
            dotnet_compiler_diagnostics_scope = 'openfiles',
        },
        ['csharp|code_lens'] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = false,
        },
        ['csharp|completion'] = {
            dotnet_show_name_completion_suggestions = true,
            dotnet_provide_regex_completions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
        },
        ['csharp|highlighting'] = {
            dotnet_highlight_related_regex_components = true,
            dotnet_highlight_related_json_components = true,
        },
        ['csharp|inlay_hints'] = {
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = false,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = false,

            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,

            csharp_enable_inlay_hints_for_types = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
        },
        ['csharp|symbol_search'] = {
            dotnet_search_reference_assemblies = true,
        },
        ['csharp|formatting'] = {
            dotnet_organize_imports_on_format = true,
        },
        ['csharp|type_members'] = {
            dotnet_member_insertion_location = 'withothermembersofthesamekind',
            dotnet_property_generation_behavior = 'preferautoproperties',
        },
        ['csharp|quick_info'] = {
            dotnet_show_remarks_in_quick_info = true,
        },
    },
}
