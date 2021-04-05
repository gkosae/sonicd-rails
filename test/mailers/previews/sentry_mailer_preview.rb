# Preview all emails at http://localhost:3000/rails/mailers/sentry_mailer
class SentryMailerPreview < ActionMailer::Preview
  def sentry_event
    event = SentryEvent.new(json)
    ::SentryMailer.sentry_event(event)
  end

  private

  def json
    %{{
      "id": "2184324339",
      "project": "prime-api",
      "project_name": "prime-api",
      "project_slug": "prime-api",
      "logger": null,
      "level": "error",
      "culprit": "raven.scripts.runner in main",
      "message": "This is an example Python exception",
      "url": "https://sentry.io/organizations/flex-digitals/issues/2184324339/?referrer=webhooks_plugin",
      "triggering_rules": [],
      "event": {
        "event_id": "febe6e7d7fe5455db8b07f7da3ff6218",
        "level": "error",
        "version": "5",
        "type": "default",
        "logentry": {
          "formatted": "This is an example Python exception",
          "message": null,
          "params": null
        },
        "logger": "",
        "modules": {
          "my.package": "1.0.0"
        },
        "platform": "python",
        "timestamp": 1611836086.343132,
        "received": 1611836086.343812,
        "environment": "prod",
        "user": {
          "id": "1",
          "email": "sentry@example.com",
          "ip_address": "127.0.0.1",
          "username": "sentry",
          "name": "Sentry",
          "geo": {
            "country_code": "AU",
            "city": "Melbourne",
            "region": "VIC"
          }
        },
        "request": {
          "url": "http://example.com/foo",
          "method": "GET",
          "data": {
            "hello": "world"
          },
          "query_string": [
            [
              "foo",
              "bar"
            ]
          ],
          "cookies": [
            [
              "foo",
              "bar"
            ],
            [
              "biz",
              "baz"
            ]
          ],
          "headers": [
            [
              "Content-Type",
              "application/json"
            ],
            [
              "Referer",
              "http://example.com"
            ],
            [
              "User-Agent",
              "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.72 Safari/537.36"
            ]
          ],
          "env": {
            "ENV": "prod"
          },
          "inferred_content_type": "application/json",
          "fragment": null
        },
        "contexts": {
          "browser": {
            "name": "Chrome",
            "version": "28.0.1500",
            "type": "browser"
          },
          "client_os": {
            "name": "Windows",
            "version": "8",
            "type": "os"
          }
        },
        "stacktrace": {
          "frames": [
            {
              "function": "build_msg",
              "module": "raven.base",
              "filename": "raven/base.py",
              "abs_path": "/home/ubuntu/.virtualenvs/getsentry/src/raven/raven/base.py",
              "lineno": 303,
              "pre_context": [
                "                frames = stack",
                "",
                "            data.update({",
                "                'sentry.interfaces.Stacktrace': {",
                "                    'frames': get_stack_info(frames,"
              ],
              "context_line": "                        transformer=self.transform)",
              "post_context": [
                "                },",
                "            })",
                "",
                "        if 'sentry.interfaces.Stacktrace' in data:",
                "            if self.include_paths:"
              ],
              "in_app": false,
              "vars": {
                "'culprit'": null,
                "'data'": {
                  "'message'": "u'This is a test message generated using ``raven test``'",
                  "'sentry.interfaces.Message'": {
                    "'message'": "u'This is a test message generated using ``raven test``'",
                    "'params'": []
                  }
                },
                "'date'": "datetime.datetime(2013, 8, 13, 3, 8, 24, 880386)",
                "'event_id'": "'54a322436e1b47b88e239b78998ae742'",
                "'event_type'": "'raven.events.Message'",
                "'extra'": {
                  "'go_deeper'": [
                    [
                      "{\"'bar'\":[\"'baz'\"],\"'foo'\":\"'bar'\"}"
                    ]
                  ],
                  "'loadavg'": [
                    0.37255859375,
                    0.5341796875,
                    0.62939453125
                  ],
                  "'user'": "'dcramer'"
                },
                "'frames'": "<generator object iter_stack_frames at 0x107bcc3c0>",
                "'handler'": "<raven.events.Message object at 0x107bd0890>",
                "'k'": "'sentry.interfaces.Message'",
                "'kwargs'": {
                  "'level'": 20,
                  "'message'": "'This is a test message generated using ``raven test``'"
                },
                "'public_key'": null,
                "'result'": {
                  "'message'": "u'This is a test message generated using ``raven test``'",
                  "'sentry.interfaces.Message'": {
                    "'message'": "u'This is a test message generated using ``raven test``'",
                    "'params'": []
                  }
                },
                "'self'": "<raven.base.Client object at 0x107bb8210>",
                "'stack'": true,
                "'tags'": null,
                "'time_spent'": null,
                "'v'": {
                  "'message'": "u'This is a test message generated using ``raven test``'",
                  "'params'": []
                }
              },
              "data": {},
              "colno": null,
              "errors": null,
              "raw_function": null,
              "image_addr": null,
              "instruction_addr": null,
              "addr_mode": null,
              "package": null,
              "platform": null,
              "symbol": null,
              "symbol_addr": null,
              "trust": null
            },
            {
              "function": "capture",
              "module": "raven.base",
              "filename": "raven/base.py",
              "abs_path": "/home/ubuntu/.virtualenvs/getsentry/src/raven/raven/base.py",
              "lineno": 459,
              "pre_context": [
                "        if not self.is_enabled():",
                "            return",
                "",
                "        data = self.build_msg(",
                "            event_type, data, date, time_spent, extra, stack, tags=tags,"
              ],
              "context_line": "            **kwargs)",
              "post_context": [
                "",
                "        self.send(**data)",
                "",
                "        return (data.get('event_id'),)",
                ""
              ],
              "in_app": false,
              "vars": {
                "'data'": null,
                "'date'": null,
                "'event_type'": "'raven.events.Message'",
                "'extra'": {
                  "'go_deeper'": [
                    [
                      "{\"'bar'\":[\"'baz'\"],\"'foo'\":\"'bar'\"}"
                    ]
                  ],
                  "'loadavg'": [
                    0.37255859375,
                    0.5341796875,
                    0.62939453125
                  ],
                  "'user'": "'dcramer'"
                },
                "'kwargs'": {
                  "'level'": 20,
                  "'message'": "'This is a test message generated using ``raven test``'"
                },
                "'self'": "<raven.base.Client object at 0x107bb8210>",
                "'stack'": true,
                "'tags'": null,
                "'time_spent'": null
              },
              "data": {},
              "colno": null,
              "errors": null,
              "raw_function": null,
              "image_addr": null,
              "instruction_addr": null,
              "addr_mode": null,
              "package": null,
              "platform": null,
              "symbol": null,
              "symbol_addr": null,
              "trust": null
            },
            {
              "function": "captureMessage",
              "module": "raven.base",
              "filename": "raven/base.py",
              "abs_path": "/home/ubuntu/.virtualenvs/getsentry/src/raven/raven/base.py",
              "lineno": 577,
              "pre_context": [
                "        \"\"\"",
                "        Creates an event from ``message``.",
                "",
                "        >>> client.captureMessage('My event just happened!')",
                "        \"\"\""
              ],
              "context_line": "        return self.capture('raven.events.Message', message=message, **kwargs)",
              "post_context": [
                "",
                "    def captureException(self, exc_info=None, **kwargs):",
                "        \"\"\"",
                "        Creates an event from an exception.",
                ""
              ],
              "in_app": false,
              "vars": {
                "'kwargs'": {
                  "'data'": null,
                  "'extra'": {
                    "'go_deeper'": [
                      "[{\"'bar'\":[\"'baz'\"],\"'foo'\":\"'bar'\"}]"
                    ],
                    "'loadavg'": [
                      0.37255859375,
                      0.5341796875,
                      0.62939453125
                    ],
                    "'user'": "'dcramer'"
                  },
                  "'level'": 20,
                  "'stack'": true,
                  "'tags'": null
                },
                "'message'": "'This is a test message generated using ``raven test``'",
                "'self'": "<raven.base.Client object at 0x107bb8210>"
              },
              "data": {},
              "colno": null,
              "errors": null,
              "raw_function": null,
              "image_addr": null,
              "instruction_addr": null,
              "addr_mode": null,
              "package": null,
              "platform": null,
              "symbol": null,
              "symbol_addr": null,
              "trust": null
            },
            {
              "function": "send_test_message",
              "module": "raven.scripts.runner",
              "filename": "raven/scripts/runner.py",
              "abs_path": "/home/ubuntu/.virtualenvs/getsentry/src/raven/raven/scripts/runner.py",
              "lineno": 77,
              "pre_context": [
                "        level=logging.INFO,",
                "        stack=True,",
                "        tags=options.get('tags', {}),",
                "        extra={",
                "            'user': get_uid(),"
              ],
              "context_line": "            'loadavg': get_loadavg(),",
              "post_context": [
                "        },",
                "    ))",
                "",
                "    if client.state.did_fail():",
                "        print('error!')"
              ],
              "in_app": false,
              "vars": {
                "'client'": "<raven.base.Client object at 0x107bb8210>",
                "'data'": null,
                "'k'": "'secret_key'",
                "'options'": {
                  "'data'": null,
                  "'tags'": null
                }
              },
              "data": {},
              "colno": null,
              "errors": null,
              "raw_function": null,
              "image_addr": null,
              "instruction_addr": null,
              "addr_mode": null,
              "package": null,
              "platform": null,
              "symbol": null,
              "symbol_addr": null,
              "trust": null
            },
            {
              "function": "main",
              "module": "raven.scripts.runner",
              "filename": "raven/scripts/runner.py",
              "abs_path": "/home/ubuntu/.virtualenvs/getsentry/src/raven/raven/scripts/runner.py",
              "lineno": 112,
              "pre_context": [
                "    print(\"Using DSN configuration:\")",
                "    print(\" \", dsn)",
                "    print()",
                "",
                "    client = Client(dsn, include_paths=['raven'])"
              ],
              "context_line": "    send_test_message(client, opts.__dict__)",
              "in_app": false,
              "vars": {
                "'args'": [
                  "'test'",
                  "'https://ebc35f33e151401f9deac549978bda11:f3403f81e12e4c24942d505f086b2cad@sentry.io/1'"
                ],
                "'client'": "<raven.base.Client object at 0x107bb8210>",
                "'dsn'": "'https://ebc35f33e151401f9deac549978bda11:f3403f81e12e4c24942d505f086b2cad@sentry.io/1'",
                "'opts'": "<Values at 0x107ba3b00: {'data': None, 'tags': None}>",
                "'parser'": "<optparse.OptionParser instance at 0x107ba3368>",
                "'root'": "<logging.Logger object at 0x107ba5b10>"
              },
              "data": {},
              "colno": null,
              "errors": null,
              "raw_function": null,
              "image_addr": null,
              "instruction_addr": null,
              "addr_mode": null,
              "package": null,
              "platform": null,
              "post_context": null,
              "symbol": null,
              "symbol_addr": null,
              "trust": null
            }
          ]
        },
        "tags": [
          [
            "browser",
            "Chrome 28.0.1500"
          ],
          [
            "browser.name",
            "Chrome"
          ],
          [
            "client_os",
            "Windows 8"
          ],
          [
            "client_os.name",
            "Windows"
          ],
          [
            "environment",
            "prod"
          ],
          [
            "level",
            "error"
          ],
          [
            "sentry:user",
            "id:1"
          ],
          [
            "server_name",
            "web01.example.org"
          ],
          [
            "url",
            "http://example.com/foo"
          ]
        ],
        "extra": {
          "emptyList": [],
          "emptyMap": {},
          "length": 10837790,
          "results": [
            1,
            2,
            3,
            4,
            5
          ],
          "session": {
            "foo": "bar"
          },
          "unauthorized": false,
          "url": "http://example.org/foo/bar/"
        },
        "fingerprint": [
          "{{ default }}"
        ],
        "hashes": [
          "3a2b45089d0211943e5a6645fb4cea3f"
        ],
        "metadata": {
          "title": "This is an example Python exception"
        },
        "title": "This is an example Python exception",
        "location": null,
        "culprit": "raven.scripts.runner in main",
        "_ref": 5612492,
        "_ref_version": 2,
        "_metrics": {
          "bytes.stored.event": 7951
        },
        "id": "febe6e7d7fe5455db8b07f7da3ff6218"
      }
    }}
  end
end
