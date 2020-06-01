class StepType
    def self.all
        [
          {
            id:   'EventFormatter',
            name: 'Event Formatter',
            default_config: {
                                instructions: {
                                                full_name:  '{{first_name}} {{last_name}}',
                                            }
                            }
            },
            {
            id:   'HtmlParser',
            name: 'HTML Parser',
            default_config: {
                                path:    'body',
                                extract: {
                                        title: {
                                                    css: 'a',
                                                    value: '@href'
                                                }
                                        }
                            }
            },
            {
            id:   'JsonParser',
            name: 'JSON Parser',
            default_config: {
                                path: 'body'
                            }
            },
            {
            id:   'ConvertXmlToData',
            name: 'Convert XML to Data',
            default_config: {
                                path: 'one.two.three'
                            }
            },
            {
            id:   'AllRecords',
            name: 'All Records',
            default_config: {
                                collection: 'TestRecords',
                                limit: '*',
                            }
            },
            {
            id:   'Splitter',
            name: 'Splitter',
            default_config: {
                                path: 'one.two.three'
                            }
            },
            {
            id:   'Trigger',
            name: 'Trigger',
            default_config: {
                                rules: [
                                        {
                                        path:  'status',
                                        type:  '==',
                                        value: '200'
                                        }
                                    ]
                            }
            },
            {
            id:   'CrudInsert',
            name: 'Upsert Record',
            queue: 'crud',
            default_config: {
                                collection: 'TestRecords',
                                record_id: '{{id}}',
                                name: '{{name}}'
                            }
            },
            {
            id:   'ManualStart',
            name: 'ManualStart' ,
            default_config: {
            }
            },
            {
            id:   'WebEndpoint',
            name: 'WebEndpoint' ,
            default_config: {
            }
            },
            {
            id:   'WebEndpointJsonResponse',
            name: 'WebEndpointJsonResponse' ,
            default_config: {
            }
            },
            {
            id:   'CronEvent',
            name: 'CronEvent',
            default_config: {
                cron: '*/2 * * * *'
            }
            },
            {
            id:   'WebRequest',
            name: 'WebRequest',
            queue: 'web_request',
            default_config: {
                                url: 'http://www.github.com',
                            }
            }
        ]
    end
end