import module.constant as constant
__author__ = 'johnson'


def transform(moment):
    return {
        'user_id': moment.user_id,
        'text': moment.text,
        'pic': moment.pic.ToXml() if moment.pic else None,
        'source_key': moment.source_key.id() if moment.source_key else None,
        'time_removed': moment.time_removed.strftime(constant.DATE_TIME_FORMAT) if moment.time_removed else None
    }
