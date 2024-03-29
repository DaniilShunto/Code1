#!/bin/bash

# SPDX-FileCopyrightText: OpenTalk GmbH <mail@opentalk.eu>
#
# SPDX-License-Identifier: EUPL-1.2

cat << EOF > /usr/local/etc/janus/janus.transport.rabbitmq.jcfg
# Configuration of the RabbitMQ additional transport for the Janus API.
# This is only useful when you're wrapping Janus requests in your server
# application, and handling the communication with clients your own way.
# At the moment, only a single "application" can be handled at the same
# time, meaning that Janus won't implement multiple queues to handle
# multiple concurrent "application servers" taking advantage of its
# features. Support for this is planned, though (e.g., through some kind
# of negotiation to create queues on the fly). Right now, you can only
# configure the address of the RabbitMQ server to use, and the queues to
# make use of to receive (to-janus) and send (from-janus) messages
# from/to an external application. If you're using the same RabbitMQ
# server instance for multiple Janus instances, make sure you configure
# different queues for each of them (e.g., from-janus-1/to-janus-1 and
# from-janus-2/to-janus-2), or otherwise both the instances will make
# use of the same queues and messages will get lost. The integration
# is disabled by default, so set enabled=true if you want to use it.
general: {
  enabled = true           # Whether the support must be enabled
  #events = true            # Whether to notify event handlers about transport events (default=true)
  json = "indented"         # Whether the JSON messages should be indented (default),
                    # plain (no indentation) or compact (no indentation and no spaces)
  host = "${RABBITMQ_HOST:-"localhost"}"          # The address of the RabbitMQ server
  port = ${RABBITMQ_PORT:-5672}            # The port of the RabbitMQ server (5672 by default)
  username = "${RABBITMQ_USERNAME:-"guest"}"         # Username to use to authenticate, if needed
  password = "${RABBITMQ_PASSWORD:-"guest"}"         # Password to use to authenticate, if needed
  vhost = "${RABBITMQ_VHOST:-"/"}"            # Virtual host to specify when logging in, if needed

  janus_exchange = "${JANUS_EXCHANGE:-"janus-exchange"}"  # Exchange for outgoing messages, using default if not provided
  janus_exchange_type = "${JANUS_EXCHANGE_TYPE:-"fanout"}"   # Rabbitmq exchange_type can be one of the available types: direct, topic, headers and fanout (fanout by defualt).
  queue_name = "${JANUS_QUEUE_NAME:-"janus-gateway"}"   # Queue name for incoming messages (if set and janus_exchange_type is topic/direct, to_janus will be the routing key the queue is bound to the exchange on)
  to_janus = "${JANUS_QUEUE_INCOMING:-"to-janus"}"       # Name of the queue for incoming messages if queue_name isn't set, otherwise, the routing key that queue_name is bound to
  from_janus = "${JANUS_ROUTING_KEY_OUTGOING:-"from-janus"}"     # Routing key of the message sent from janus (as well as the name of the outgoing queue if declare_outgoing_queue = true)
  declare_outgoing_queue = false    # By default (for backwards compatibility), we declare an outgoing queue. Set this to false to disable that behavior
  #queue_durable = false        # Whether or not incoming queue should remain after a RabbitMQ reboot
  #queue_autodelete = false     # Whether or not incoming queue should autodelete after janus disconnects from RabbitMQ
  #queue_exclusive = false      # Whether or not incoming queue should only allow one subscriber

  #ssl_enabled = false        # Whether ssl support must be enabled
  #ssl_verify_peer = true       # Whether peer verification must be enabled
  #ssl_verify_hostname = true     # Whether hostname verification must be enabled

  # Certificates to use when SSL support is enabled, if needed
  #ssl_cacert = "/path/to/cacert.pem"
  #ssl_cert = "/path/to/cert.pem"
  #ssl_key = "/path/to/key.pem"
}

# If you want to expose the Admin API via RabbitMQ as well, you need to
# specify a different set of queues, as you cannot mix Janus API and
# Admin API messaging. The same RabbitMQ server is supposed to be used.
# Notice that by default the Admin API support via RabbitMQ is disabled.
admin: {
  #admin_enabled = false            # Whether the support must be enabled

  #queue_name_admin = "janus-gateway-admin" # Queue name for incoming admin messages (if set and janus_exchange_type is topic/direct, to_janus_admin will be the the routing key the queue is bound to the exchange on)
  #to_janus_admin = "to-janus-admin"      # Name of the queue for incoming messages if queue_name_admin isn't set, otherwise, the routing key that queue_name_admin is bound to
  #from_janus_admin = "from-janus-admin"    # Routing key of the message sent from janus  (as well as the name of the outgoing queue if declare_outgoing_queue_admin = true)
  #declare_outgoing_queue_admin = true    # By default (for backwards compatibility), we declare an outgoing queue. Set this to false to disable that behavior
  #queue_durable_admin = false        # Whether or not incoming queue should remain after a RabbitMQ reboot
  #queue_autodelete_admin = false       # Whether or not incoming queue should autodelete after janus disconnects from RabbitMQ
  #queue_exclusive_admin = false        # Whether or not incoming queue should only allow one subscriber

}
EOF
