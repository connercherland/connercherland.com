export default {
  name: 'show',
  title: 'Show',
  type: 'document',
  fields: [
    {
      name: 'location',
      title: 'Location',
      type: 'reference',
      to: {type: 'venue'}
    },
    {
      name: 'startTime',
      title: 'Start Time',
      type: 'datetime',
    },
    {
      name: 'endTime',
      title: 'End Time',
      type: 'datetime',
    },
  ],

  preview: {
    select: {
      title: 'title',
      manufactor: 'manufactor.title',
      media: 'defaultProductVariant.images[0]'
    }
  }
}
