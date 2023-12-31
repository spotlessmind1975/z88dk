

#include <cpm.h>
#include <string.h>

int cpm_cache_get(struct fcb *fcb, unsigned long record_nr, int for_read)
{
    // We've already got it cached, just use it
    if ( record_nr == fcb->cached_record ) return 0;

    if ( cpm_cache_flush(fcb)) return -1;

    fcb->cached_record = 0xffffffff;
    _putoffset(fcb->ranrec,record_nr);
    bdos(CPM_SDMA,fcb->buffer);
    if ( bdos(CPM_RRAN,fcb) ) {
        if ( for_read ) return -1;
        // It's for a write, unknown sector, fill with EOF marker
        memset(fcb->buffer, 26, SECSIZE);
    }
    fcb->cached_record = record_nr;
    return 0;
}

/**
 * \retval 0 = Nothing to do
 * \retval 1 = Flushed cache
 * \retval -1 = Error flushing
 */
int cpm_cache_flush(struct fcb *fcb)
{
    if ( fcb->dirty ) {
        _putoffset(fcb->ranrec,fcb->cached_record);
        bdos(CPM_SDMA,fcb->buffer);
        if ( bdos(CPM_WRAN,fcb) == 0 ) {
            fcb->dirty = 0;
            return 1;
        }
        return -1;
    }
    return 0;
}
