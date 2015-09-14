require 'dummy_worker'

SidekiqSchedule.worker_classes = [DummyWorker.name]